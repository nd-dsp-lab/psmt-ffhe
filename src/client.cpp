#include <openfhe.h>
#include "HE.h"
#include "core.h"
#include "client.h"

using namespace lbcrypto;

// Encodes single ciphertext
std::vector<int64_t> encodeDataClient (
    const std::vector<int64_t> &dataVec,
    int64_t prime
) {
    int32_t logp = (int)(std::log2(prime));
    int32_t lenData = dataVec.size();
    int32_t expRate = 64 / logp + (64 & logp != 0);
    int64_t mask = (1<<logp) - 1;

    std::vector<int64_t> ret;
    for (int32_t i = 0; i < expRate * lenData; i++) {
        uint32_t itemIdx = i / expRate;
        uint32_t lkupIdx = i % expRate;
        uint64_t currVal = dataVec[itemIdx];
        uint64_t currMask = mask << (logp * lkupIdx);
        ret.push_back((currVal & currMask) >> (logp * lkupIdx));
    }
    return ret;
}

bool checkIntResult (
    HE &bfv,
    Ciphertext<DCRTPoly> resCtxt
) {
    Plaintext ret = bfv.decrypt(resCtxt);
    std::vector<int64_t> retVec =  ret->GetPackedValue();
    // Check whether there is "1" in the received vector.
    for (int32_t i = 0; i < bfv.ringDim; i++) {
        if (retVec[i] == 1) {
            return true;
        }
    }
    return false;
}