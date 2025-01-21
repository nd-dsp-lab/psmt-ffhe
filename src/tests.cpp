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

void runTest() {
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

void testEncoding() {
    std::vector<std::vector<int64_t>> serverMsg;

    for (int i = 0; i < 2; i++) {
        serverMsg.push_back( {theAnswer, theAnswer, theAnswer, theAnswer});        
    }

    auto ret = encodeData(serverMsg, 65537);
    for (int i = 0; i < 16; i++) {
        std::cout << ret[i] << std::endl;
    }
}

void testVAFs() {

}