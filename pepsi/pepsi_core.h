#ifndef PEPSI_CORE_H
#define PEPSI_CORE_H

#include <openfhe.h>
#include "HE.h"

using namespace lbcrypto;

std::vector<std::vector<uint64_t>> chooseTable(uint64_t n);

std::vector<int64_t> getCW(
    uint64_t data,
    uint32_t numCtxt,
    uint32_t kVal
);


Ciphertext<DCRTPoly> arithCWEQ(
    HE &bfv,
    std::vector<Ciphertext<DCRTPoly>> ctxt1,
    // std::vector<Plaintext> ctxt2,
    std::vector<Ciphertext<DCRTPoly>> ctxt2,    
    Plaintext ptDiv,
    uint32_t kVal
);

Ciphertext<DCRTPoly> arithCWEQPtxt(
    HE &bfv,
    std::vector<Ciphertext<DCRTPoly>> ctxt,
    std::vector<Plaintext> ptxt,
    Plaintext ptDiv,
    uint32_t kVal
);

std::vector<int64_t> getCWTable(
    uint64_t data,
    uint32_t numCtxt,
    uint32_t kVal,
    std::vector<std::vector<uint64_t>> table
);

#endif