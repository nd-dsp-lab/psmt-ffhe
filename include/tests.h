#ifndef TEST_H
#define TEST_H

#include "HE.h"
#include "server.h"
#include "client.h"

// Main Test Functions
void testFullProtocol(
    uint64_t numItem,
    uint32_t lenData,
    uint32_t numPack,
    uint32_t numAgg,
    int32_t alpha,
    const std::string& interType    
);

void testEncoding();
void testVAFs();
void testNPC();
void testBasicOPs();
void testProbNPC(int k);
void testAgg(int numParties);

void testAllBackends();

#endif