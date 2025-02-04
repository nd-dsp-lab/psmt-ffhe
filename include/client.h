#ifndef CLIENT_H
#define CLIENT_H

std::vector<int64_t> encodeDataClient (
    const std::vector<uint32_t> &dataVec,
    int64_t prime
);

Ciphertext<DCRTPoly> encryptQuery(
    HE &bfv,
    std::vector<int64_t> dataPrepared
);

bool checkIntResult (
    HE &bfv,
    Ciphertext<DCRTPoly> resCtxt
);

#endif