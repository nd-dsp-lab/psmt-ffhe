#include <openfhe.h>
#include "tests.h"

using namespace lbcrypto;
#define theAnswer 0x002A002A002A002A
#include <chrono>

// Helper for Simulation
std::vector<std::vector<int64_t>> genData(
    int32_t numItem,
    int32_t lenData
) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int64_t> dist(0, (1 << 16) - 1);

    std::vector<std::vector<int64_t>> ret;
    for (int32_t i = 0; i < numItem; i++) {
        std::vector<int64_t> _tmp;
        for (int32_t i = 0; i < lenData; i++) {
            _tmp.push_back(dist(gen));
        }
        ret.push_back(_tmp);
    }
    return ret;
}

void testFullProtocol() {
    std::cout << "TEST START!" << std::endl;

    std::cout << "Step 1-1: Setup FHE" << std::endl;
    HE bfv("BFV", 65537, 18);

    std::cout << "Step 1-2: Setup Databases" << std::endl;
    std::vector<int64_t> clientMsg = {theAnswer, theAnswer, theAnswer, theAnswer};
    std::vector<std::vector<int64_t>> serverMsg = genData(
        (1<<20), 1
    );  

    // Inject Server's MSG
    serverMsg[42] = {theAnswer, theAnswer, theAnswer, theAnswer};

    std::cout << "Step 1-3: Server Side Preprocessing" << std::endl;
    EncryptedDB serverDB = constructEncDB(
        bfv,
        serverMsg,
        1,
        3
    );

    std::cout << "Step 2: Client Side Computation" << std::endl;
    // Client Prepares and Encrypts the database
    auto clientPrepMsg  = encodeDataClient(
        clientMsg, bfv.prime
    );

    std::cout << "Step 3: Query Encryption" << std::endl;
    auto queryCtxt = bfv.encrypt(bfv.packing(clientPrepMsg));

    std::cout << "Step 4: Do Intersection" << std::endl;
    auto t1 = std::chrono::high_resolution_clock::now();
    auto interResCtxt = compInterDB(
        bfv, serverDB, queryCtxt
    );
    auto t2 = std::chrono::high_resolution_clock::now();
    double timeSec = std::chrono::duration<double>(t2 - t1).count();
    std::cout << "Intersection Done! Time Elapsed: " << timeSec << "s" << std::endl;


    std::cout << "Step 5: Receive Result" << std::endl;
    auto ret = checkIntResult(bfv, interResCtxt);

    std::cout << "Inter Result: " << ret << std::endl;
}

// Helper Functions for pack integers
std::vector<int64_t> intPacking(std::vector<uint16_t> shortVec) {
    std::vector<int64_t> ret;
    uint64_t _tmp;
    uint32_t numShorts = shortVec.size();

    for (uint32_t i = 0; i < numShorts / 4; i++) {
        _tmp = 0;
        // Read 16 Bits and Pack into a 64-bit integer.
        for (uint32_t j = 0; j < 4; j++) {
            _tmp += (int64_t)(shortVec[4*i + j] & 0xffff) << ((16 * j));
        }
        ret.push_back(_tmp);
    }
    return ret;
}

// Test Code for Encoding
void testEncoding() {
    std::vector<std::vector<int64_t>> serverMsg;

    std::cout << "<<< Test Code for Encoding >>>" << std::endl;
    
    for (int i = 0; i < 4; i++) {
        serverMsg.push_back(intPacking({
            0,1,2,3,
            4,5,6,7,
            8,9,10,11,
            12,13,14,15
        }));        
    }

    std::cout << "Sever Message: " << serverMsg[0] << std::endl;

    auto ret = encodeData(serverMsg, 65537);
    for (int i = 0; i < 16; i++) {
        std::cout << ret[i] << std::endl;
    }
}

// Test code for VAF
void testVAFs() {
    std::cout << "<<< Test Code for VAFs >>>" << std::endl;

    // Test 1
    {
        std::cout << "Test 1: Compute VAF for p = 2^16 + 1" << std::endl;
        HE bfv("BFV", 65537, 20);
        std::vector<int64_t> msgVec(1<<15, 42);
        std::vector<int64_t> msgOne(1<<15, 1);
        msgVec[7] = 0;
        auto ptxt = bfv.packing(msgVec);
        auto ptOne = bfv.packing(msgOne);
        auto ctxt = bfv.encrypt(ptxt);
        auto ret = compVAF16(bfv, ctxt, ptOne);
        std::vector<int64_t> retVec = bfv.decrypt(ret)->GetPackedValue();

        std::cout << "<<< 8th Result Should be 1 >>>" << std::endl;
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;
    }

    // Test 2
    {
        std::cout << "Test 2: Compute VAF for p = 2^23 + 2^17 + 1" << std::endl;
        HE bfv("BFV", (65 << 17) + 1, 25);
        std::vector<int64_t> msgVec(1<<16, 42);
        std::vector<int64_t> msgOne(1<<16, 1);
        msgVec[7] = 0;
        auto ptxt = bfv.packing(msgVec);
        auto ptOne = bfv.packing(msgOne);
        auto ctxt = bfv.encrypt(ptxt);
        auto ret = compVAF(bfv, ctxt, (65 << 17) + 1, ptOne);
        auto retVec = bfv.decrypt(ret)->GetPackedValue();

        std::cout << "<<< 8th Result Should be 1 >>>" << std::endl;
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;    
    }
    
}

// Test code for NPC
void testNPC() {
    std::cout << "<<< Test Code for NPCs >>>" << std::endl;

    // Test 1
    {
        std::cout << "Test 1: Compute NPC for k = 4" << std::endl;
        HE bfv("BFV", 65537, 20);        
        std::vector<Ciphertext<DCRTPoly>> ctxts;
        Plaintext _tmpPtxt; Ciphertext<DCRTPoly> _tmpCtxt;
        std::vector<int64_t> msgAlpha(1<<15, 3);
        Plaintext ptAlpha = bfv.packing(msgAlpha);        
        int k = 4;

        std::cout << "<<< 4th Result Should be 0 >>>" << std::endl;
        for (int i = 0; i < k; i++) {
            std::vector<int64_t> msgVec(1<<15, 42);
            msgVec[3] = 0;
            _tmpPtxt = bfv.packing(msgVec);
            _tmpCtxt = bfv.encrypt(_tmpPtxt);
            ctxts.push_back(_tmpCtxt);
        }

        // Run NPCs
        auto ret = compNPC(bfv, ctxts, ptAlpha);
        auto retVec = bfv.decrypt(ret)->GetPackedValue();
        std::cout << "<<< 4th Result Should be 0 >>>" << std::endl;
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;
    }

    // Test 2
    {
        std::cout << "Test 2: Compute NPC for k = 16" << std::endl;
        HE bfv("BFV", 65537, 20);        
        std::vector<Ciphertext<DCRTPoly>> ctxts;
        Plaintext _tmpPtxt; Ciphertext<DCRTPoly> _tmpCtxt;        
        std::vector<int64_t> msgAlpha(1<<15, 3);
        Plaintext ptAlpha = bfv.packing(msgAlpha);

        int k = 16;
        for (int i = 0; i < k; i++) {
            std::vector<int64_t> msgVec(1<<15, 42);
            msgVec[3] = 0;
            _tmpPtxt = bfv.packing(msgVec);
            _tmpCtxt = bfv.encrypt(_tmpPtxt);
            ctxts.push_back(_tmpCtxt);
        }

        // Run NPCs
        std::cout << "<<< 4th Result Should be 0 >>>" << std::endl;        
        auto ret = compNPC(bfv, ctxts, ptAlpha);
        auto retVec = bfv.decrypt(ret)->GetPackedValue();
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;
    }    

    // Test 3
    {
        std::cout << "Test 3: Compute NPC for k = 12" << std::endl;
        HE bfv("BFV", 65537, 20);        
        std::vector<Ciphertext<DCRTPoly>> ctxts;
        Plaintext _tmpPtxt; Ciphertext<DCRTPoly> _tmpCtxt;       
        std::vector<int64_t> msgAlpha(1<<15, 3);
        Plaintext ptAlpha = bfv.packing(msgAlpha);         
        int k = 12;
        for (int i = 0; i < k; i++) {
            std::vector<int64_t> msgVec(1<<15, 42);
            msgVec[3] = 0;
            _tmpPtxt = bfv.packing(msgVec);
            _tmpCtxt = bfv.encrypt(_tmpPtxt);
            ctxts.push_back(_tmpCtxt);
        }

        // Run NPCs
        auto ret = compNPC(bfv, ctxts, ptAlpha);
        auto retVec = bfv.decrypt(ret)->GetPackedValue();
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;
    }        
}


// Test code for all backends
void testAllBackends() {
    // More test functions will be added.
    testEncoding();
    testVAFs();
    testNPC();
}