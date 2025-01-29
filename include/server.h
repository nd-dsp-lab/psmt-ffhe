#ifndef SERVER_H
#define SERVER_H

#include "HE.h"
#include <openfhe.h>
#include "core.h"

using namespace lbcrypto;

// Encrypted Database for a single Server
// We will the entire dataset by the collection of "chunks"
// Chunk with metadata;
typedef struct _EncryptedChunk {
    int32_t ringDim;
    int32_t numPack;
    int32_t kVal;
    int64_t prime;    
    std::vector<Ciphertext<DCRTPoly>> payload;
} EncryptedChunk;

// Main Database
typedef struct _EncryptedDB {
    int32_t ringDim;
    int32_t numChunks;
    int32_t numPack;
    int32_t kVal;
    int64_t prime;  
    std::vector<EncryptedChunk> chunks;
    // Pre-computed Plaintexts
    std::vector<Plaintext> masks;
    Plaintext ptAlpha; Plaintext ptOne;
    // Mask for the Final Process
    Plaintext finalMask;
} EncryptedDB;

// Precomputing Masks
std::vector<Plaintext> compMasks (
    HE &bfv,
    int32_t ringDim,
    int32_t numPack,
    int32_t kVal
);

// Data Encoding Method
std::vector<std::vector<int64_t>> encodeData (
    const std::vector<std::vector<int64_t>> &dataVec,
    int64_t prime
);

// Construct an Encrypted Database
EncryptedDB constructEncDB (
    HE &bfv,
    const std::vector<std::vector<int64_t>> &dataVec,
    int32_t numPack,
    int32_t alpha
);

// Ciphertext Extraction
std::vector<Ciphertext<DCRTPoly>> extractCtxts (
    HE &bfv,
    Ciphertext<DCRTPoly> queryCtxt,
    int32_t numPack,
    int32_t kVal,
    const std::vector<Plaintext> masks
);

// Intersection Functions
Ciphertext<DCRTPoly> compInter (
    HE &bfv,
    const EncryptedChunk &chunk,
    const std::vector<Ciphertext<DCRTPoly>> &extCtxts,
    Plaintext ptAlpha,
    Plaintext ptOne
);

Ciphertext<DCRTPoly> compInterNoVAF (
    HE &bfv,
    const EncryptedChunk &chunk,
    const std::vector<Ciphertext<DCRTPoly>> &extCtxts,
    Plaintext ptAlpha
);

Ciphertext<DCRTPoly> compProbInter (
    HE &bfv,
    const EncryptedChunk &chunk,
    const std::vector<Ciphertext<DCRTPoly>> &extCtxts,
    Plaintext ptAlpha,
    Plaintext ptOne
);

// Main Functions
Ciphertext<DCRTPoly> compInterDB (
    HE &bfv,
    const EncryptedDB &DB,
    Ciphertext<DCRTPoly> queryCtxt
);

Ciphertext<DCRTPoly> compInterDBHybrid (
    HE &bfv,
    const EncryptedDB &DB,
    Ciphertext<DCRTPoly> queryCtxt
);

Ciphertext<DCRTPoly> compProbInterDB (
    HE &bfv,
    const EncryptedDB &DB,
    Ciphertext<DCRTPoly> queryCtxt
);

#endif