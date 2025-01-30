#ifndef TEST_H
#define TEST_H

#include "HE.h"
#include "server.h"
#include "client.h"

// Main Test Functions
void testFullProtocol();
void testEncoding();
void testVAFs();
void testNPC();
void testBasicOPs();
void testProbNPC(int k);
void testAgg(int numParties);

void testAllBackends();

#endif