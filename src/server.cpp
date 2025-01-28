// Operations for Server
#include <openfhe.h>
#include <omp.h>
#include "server.h"
#include "HE.h"
#include "core.h"

using namespace lbcrypto;

// Helpers for DB construction
// Number 1: Pre-Compute Masks
std::vector<Plaintext> compMasks (
    HE &bfv,
    int32_t ringDim,
    int32_t numPack,
    int32_t kVal
) {
    std::vector<Plaintext> ret;

    // Number of Mask = kVal / numPack
    int32_t numMasks = kVal / numPack;
    // TODO: throw an error when it is not divisible.

    // Copmute Mask
    for (int32_t i = 0; i < numMasks; i++) {
        std::vector<int64_t> tmp(ringDim, 0);

        // Put 1's for the desired positions
        for (int32_t j = 0; j < ringDim / kVal; j++) {
            for (int32_t l = 0; l < numPack; l++) {
                tmp[j * kVal + numPack * i + l] = 1;
            }
        }
        Plaintext ptxt = bfv.packing(tmp);
        ret.push_back(ptxt);
    }
    return ret;
}

// Number 2: Data Encoding
std::vector<std::vector<int64_t>> encodeData (
    const std::vector<std::vector<int64_t>> &dataVec,
    int64_t prime
) {
    // Some useful Values
    int32_t logp = (int)(std::log2(prime));
    int32_t lenData = dataVec[0].size();
    int32_t expRate = 64 / logp + (64 & logp != 0);
    int64_t numItems = dataVec.size();
    int64_t mask = (1<<logp) - 1;

    // Encoding Procedure
    std::vector<std::vector<int64_t>> ret;

    for (int32_t i = 0; i < expRate * lenData; i++) {
        std::vector<int64_t> _tmp;
        int32_t itemIdx = i / expRate;
        int32_t lkupIdx = i % expRate;

        for (int32_t j = 0; j < numItems; j++) {
            uint64_t currVal = dataVec[j][itemIdx];
            uint64_t currMask = mask << (logp * lkupIdx);
            _tmp.push_back((currVal & currMask) >> (logp * lkupIdx));
        }
        ret.push_back(_tmp);
    }
    return ret;
}


// Main Construction Function
EncryptedDB constructEncDB (
    HE &bfv,
    const std::vector<std::vector<int64_t>> &dataVec,
    int32_t numPack,
    int32_t alpha
) {
    int32_t ringDim = bfv.ringDim;
    int64_t prime = bfv.prime;


    // Step 1. Encode Data
    std::vector<std::vector<int64_t>> encVec = encodeData(
        dataVec, prime
    );

    // TODO: Patch this code
    int32_t kVal = encVec.size();

    // Step 2. Construct each Chunks
    int64_t numItems = dataVec.size();
    int64_t capacity = ringDim / numPack;
    int32_t numChunks = numItems / capacity + (numItems % capacity != 0);
    
    std::vector<EncryptedChunk> chunks;
    Plaintext _ptxt;
    Ciphertext<DCRTPoly> _ctxt;

    // Encryption Goes Here.
    for (int32_t i = 0; i < numChunks; i++) {
        std::vector<Ciphertext<DCRTPoly>> payload;
        // Offset for Item Number
        int64_t offset = capacity * i; 
        // # of Ctxts per chunk: kVal / numPack
        for (int32_t j = 0; j < kVal/numPack; j++) {
            std::vector<int64_t> _tmp;
            // Read encVec according to indices
            for (int32_t k = 0; k < capacity; k++) {
                for (int32_t l = 0; l < numPack; l++) {
                    // check validity
                    // for out of indices, just encode 0.
                    if (offset + k >= numItems || j * numPack + l >= kVal) {
                        _tmp.push_back(0);
                    } else {
                        _tmp.push_back(
                            encVec[j * numPack + l][offset + k]
                        );
                    }
                }
            }
            _ptxt = bfv.packing(_tmp);
            _ctxt = bfv.encrypt(_ptxt);
            payload.push_back(_ctxt);
        }
        EncryptedChunk chunk {
            ringDim, numPack, kVal, prime, payload
        };
        chunks.push_back(chunk);        
    }


    // Step 3. Compute Masks
    std::vector<Plaintext> masks = compMasks(
        bfv, ringDim, numPack, kVal
    );

    // Final Mask
    std::vector<int64_t> _tmp(ringDim, 0);
    for (int32_t i = 0; i < ringDim; i = i + numPack) {
        _tmp[i] = 1;
    }
    Plaintext finalMask = bfv.packing(_tmp);

    // Other tools
    std::vector<int64_t> alphaVec(ringDim, alpha);
    std::vector<int64_t> oneVec(ringDim, 1);
    Plaintext ptAlpha = bfv.packing(alphaVec);
    Plaintext ptOne = bfv.packing(oneVec);

    return EncryptedDB {
        ringDim, numChunks, numPack,
        kVal, prime, chunks,
        masks, ptAlpha, ptOne, finalMask
    };
}

// Extraction Function
std::vector<Ciphertext<DCRTPoly>> extractCtxts (
    HE &bfv,
    Ciphertext<DCRTPoly> queryCtxt,
    int32_t numPack,
    int32_t kVal,
    const std::vector<Plaintext> masks
) {

    int32_t numMasks = masks.size();
    std::vector<Ciphertext<DCRTPoly>> ret;

    // No need for extraction
    if (numPack == kVal) {
        ret.push_back(queryCtxt);
        return ret;
    }

    // Temporary ctxts
    Ciphertext<DCRTPoly> _tmp, __tmp;

    // Extraction goes here
    for (int32_t i = 0; i < numMasks; i++) {
        // Multiply Mask
        _tmp = bfv.mult(queryCtxt, masks[i]);

        // Rotate and Add to fill them up.
        for (int32_t j = numPack; j < kVal; j *= 2) {
            __tmp = bfv.rotate(_tmp, j);
            _tmp = bfv.add(_tmp, __tmp);
        }
        ret.push_back(_tmp);
    }
    return ret;
}


// Do Intersection
Ciphertext<DCRTPoly> compInter (
    HE &bfv,
    const EncryptedChunk &chunk,
    const std::vector<Ciphertext<DCRTPoly>> &extCtxts,
    Plaintext ptAlpha,
    Plaintext ptOne
) { 
    // Compute Difference
    int32_t numCtxts = extCtxts.size();
    // Differences
    std::vector<Ciphertext<DCRTPoly>> diffCtxts;

    // TODO: throw an error when sizes do not match
    for (int32_t i = 0; i < numCtxts; i++) {
        diffCtxts.push_back(
            bfv.sub(chunk.payload[i], extCtxts[i])
        );
    }

    // Run NPC
    Ciphertext<DCRTPoly> ret = compNPC(
        bfv, diffCtxts, ptAlpha
    );

    // Compute VAF
    ret = compVAF(bfv, ret, chunk.prime, ptOne);

    // Multiplicative Aggregation (Optional)
    if (chunk.numPack == 1) {
        return ret;
    } else {
        ret = compRotMult(
            bfv, ret, chunk.numPack
        );
        return ret;
    }
}

// Do Intersection without running VAFs
Ciphertext<DCRTPoly> compInterNoVAF (
    HE &bfv,
    const EncryptedChunk &chunk,
    const std::vector<Ciphertext<DCRTPoly>> &extCtxts,
    Plaintext ptAlpha
) {
    // Compute Difference
    int32_t numCtxts = extCtxts.size();
    // Differences
    std::vector<Ciphertext<DCRTPoly>> diffCtxts;

    // TODO: throw an error when sizes do not match
    for (int32_t i = 0; i < numCtxts; i++) {
        diffCtxts.push_back(
            bfv.sub(chunk.payload[i], extCtxts[i])
        );
    }

    // Run NPC
    Ciphertext<DCRTPoly> ret = compNPC(
        bfv, diffCtxts, ptAlpha
    );

    // Aggregation (Optional)
    if (chunk.numPack == 1) {
        return ret;
    } else {
        ret = compRotNPC(
            bfv, ret, chunk.numPack, ptAlpha
        );
        return ret;
    }
}

// Main Intersection Function 
Ciphertext<DCRTPoly> compInterDB (
    HE &bfv,
    const EncryptedDB &DB,
    Ciphertext<DCRTPoly> queryCtxt
) {
    // Extract Query Cipehrtext
    std::vector<Ciphertext<DCRTPoly>> extCtxts = extractCtxts(
        bfv, queryCtxt, DB.numPack, DB.kVal, DB.masks
    );

    std::vector<Ciphertext<DCRTPoly>> chunkIntRes;
    Ciphertext<DCRTPoly> chunkRet;

    #pragma omp parallel for
    for (int32_t i = 0; i < DB.numChunks; i++) {
        // TODO: Parallelization
        chunkRet = compInter(
            bfv, DB.chunks[i], extCtxts,
            DB.ptAlpha, DB.ptOne
        );
        chunkIntRes.push_back(chunkRet);
    }

    // Aggregation
    // Additive Aggregation
    Ciphertext<DCRTPoly> ret = bfv.addmany(chunkIntRes);

    // Final Masking
    if (DB.numPack == 1) {
        return ret;
    } else {
        ret = bfv.mult(ret, DB.finalMask);
        return ret;
    }
}

// Main Intersection Function with Hybrid Aggregation
Ciphertext<DCRTPoly> compInterDBHybrid (
    HE &bfv,
    const EncryptedDB &DB,
    Ciphertext<DCRTPoly> queryCtxt
) {
    // Extract Query Ciphertext
    std::vector<Ciphertext<DCRTPoly>> extCtxts = extractCtxts(
        bfv, queryCtxt, DB.numPack, DB.kVal, DB.masks
    );

    std::vector<Ciphertext<DCRTPoly>> chunkIntRes;

    #pragma omp parallel for
    for (int32_t i = 0; i < DB.numChunks; i++) {
        // TODO: Parallelization
        chunkIntRes.push_back(
            compInterNoVAF(
                bfv, DB.chunks[i], extCtxts, DB.ptAlpha
            )
        );
    }

    // Aggregation
    // Multiplicative Aggr
    Ciphertext<DCRTPoly> ret = bfv.multmany(chunkIntRes);
    ret = compVAF(bfv, ret, DB.prime, DB.ptOne);

    // Final Masking
    if (DB.numPack == 1) {
        return ret;
    } else {
        ret = bfv.mult(ret, DB.finalMask);
        return ret;
    }    
}