#ifndef CLIENT_H
#define CLIENT_H

std::vector<int64_t> encodeDataClient (
    const std::vector<int64_t> &dataVec,
    int64_t prime
);

bool checkIntResult (
    HE &bfv,
    Ciphertext<DCRTPoly> resCtxt
);

#endif