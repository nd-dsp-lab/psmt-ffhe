#include <openfhe.h>
#include "tests.h"

using namespace lbcrypto;
#define theAnswer 0x002A002A
#include <chrono>

// Helper for Simulation
std::vector<std::vector<uint32_t>> genData(
    int32_t numItem,
    int32_t lenData
) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<uint32_t> dist(0, (1 << 16) - 1);

    std::vector<std::vector<uint32_t>> ret;
    for (int32_t i = 0; i < numItem; i++) {
        std::vector<uint32_t> _tmp;
        for (int32_t i = 0; i < lenData; i++) {
            _tmp.push_back(dist(gen));
        }
        ret.push_back(_tmp);
    }
    return ret;
}

// Useful Promes
# define Prime16 65537
# define Prime19 786433
# define Prime23 8519681
# define Prime31 4293918721 
# define Prime33 8590983169


size_t ctxtSize(Ciphertext<DCRTPoly>& ctxt) {
  size_t size = 0;
  for (auto& element : ctxt->GetElements()) {
    for (auto& subelements : element.GetAllElements()) {
      auto lenght = subelements.GetLength();
      size += lenght * sizeof(subelements[0]);
    }
  }
  return size;
};


// Main Test Code
void testFullProtocol(
    uint64_t numItem,
    uint32_t lenData,
    uint32_t numPack,
    uint32_t numAgg,
    int32_t alpha,
    const std::string& interType    
) {
    std::cout << "TEST START! - Parameters" << std::endl;
    std::cout << "numItem: \t" << numItem << std::endl;
    std::cout << "lenData: \t" << lenData * 32 << std::endl;
    std::cout << "numPack: \t" << numPack << std::endl;
    std::cout << "numAgg: \t" << numAgg << std::endl;
    std::cout << "alpha: \t\t" << alpha << std::endl;
    std::cout << "Inter Type: \t" << interType << std::endl;

    // Depth Calculator
    // TODO: Support various primes
    uint32_t depth = 16;
    if (interType == "CIH" || interType == "CPIH") {
        depth += (int)(std::log2(numAgg));
    }    
    if (interType == "CPI" || interType == "CPIH") {
        depth += 3;
    } else {
        depth += (int)(std::log2(lenData)) + 1;
    }

    // Parameter Not Supported
    if (depth > 23) {
        throw std::runtime_error("Depth is TOO high...");
    }

    std::cout << "Depth: \t\t" << depth << std::endl;    

    std::cout << "TEST START!" << std::endl;    
    std::cout << "Step 1-1: Setup FHE" << std::endl;
    HE bfv("BFV", Prime16, depth);

    std::cout << "Step 1-2: Setup Databases" << std::endl;
    std::vector<uint32_t> clientMsg(lenData, theAnswer);
    std::vector<std::vector<uint32_t>> serverMsg = genData(
        (1<<numItem),    // numItem
        lenData          // lenData; total size = lenData * 32
    );  

    // Inject Server's MSG
    serverMsg[42] = std::vector<uint32_t>(lenData, theAnswer);

    std::cout << "Step 1-3: Server Side Preprocessing" << std::endl;
    EncryptedDB serverDB = constructEncDB(
        bfv,
        serverMsg,  // dataVec
        numPack,    // numPack
        alpha,          // alpha
        numAgg      // numAgg 
    );

    std::cout << "Step 2: Client Side Computation" << std::endl;
    // Client Prepares and Encrypts the database
    auto clientPrepMsg  = encodeDataClient(
        clientMsg, bfv.prime
    );

    std::cout << "Step 3: Query Encryption" << std::endl;
    auto queryCtxt = bfv.encrypt(bfv.packing(clientPrepMsg));

    size_t querySize = ctxtSize(queryCtxt);

    std::cout << "Step 4: Do Intersection" << std::endl;

    Ciphertext<DCRTPoly> interResCtxt;

    auto t1 = std::chrono::high_resolution_clock::now();
    if (interType == "CI") {        
        interResCtxt = compInterDB(
            bfv, serverDB, queryCtxt
        );        
    } else if (interType == "CPI") {
        interResCtxt = compProbInterDB(
            bfv, serverDB, queryCtxt
        );
    } else if (interType == "CIH") {
        interResCtxt = compInterDBHybrid(
            bfv, serverDB, queryCtxt
        );
    } else if (interType == "CPIH") {
        interResCtxt = compProbInterDBHybrid(
            bfv, serverDB, queryCtxt
        );
    } else {
        throw std::runtime_error("Invalid Inter Type: " + interType);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double timeSec = std::chrono::duration<double>(t2 - t1).count();
    std::cout << "Intersection Done! Time Elapsed: " << timeSec << "s" << std::endl;

    std::cout << "Step 5: Receive Result" << std::endl;
    auto ret = checkIntResult(bfv, interResCtxt);

    std::cout << "Inter Result: " << ret << std::endl;
    std::cout << "Query Size: " << (double)(querySize) / 1000000 << "Mb" << std::endl;
}

// Helper Functions for pack integers
// std::vector<uint32_t> intPacking(std::vector<uint64_t> shortVec) {
//     std::vector<int64_t> ret;
//     uint64_t _tmp;
//     uint32_t numShorts = shortVec.size();

//     for (uint32_t i = 0; i < numShorts / 4; i++) {
//         _tmp = 0;
//         // Read 16 Bits and Pack into a 64-bit integer.
//         for (uint32_t j = 0; j < 4; j++) {
//             _tmp += (int32_t)(shortVec[4*i + j] & 0xffff) << ((16 * j));
//         }
//         ret.push_back(_tmp);
//     }
//     return ret;
// }

// Test Code for Encoding
void testEncoding() {
    std::vector<std::vector<uint32_t>> serverMsg;

    std::cout << "<<< Test Code for Encoding >>>" << std::endl;
    
    for (int i = 0; i < 4; i++) {
        std::vector<uint32_t> tmp = {
            90,12,29,37,
            42,53,68,71,
            80,95,10,11,
            122,143,147,1590
        };
        serverMsg.push_back(tmp);        
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

void testRotAdd() {
    std::cout << "<<< Test Code for Rotation and Addition Technique >>>" << std::endl;

    // Test 1
    {
        HE bfv("BFV", 65537, 20);        
        std::vector<int64_t> msgVec = {1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0};
        auto ptxt = bfv.packing(msgVec);
        auto ctxt = bfv.encrypt(ptxt);
        int32_t kVal = 4;
        int32_t numPack = 1;

        Ciphertext<DCRTPoly> _tmp;

        for (int i = numPack; i < kVal; i *= 2 ) {
            _tmp = bfv.rotate(ctxt, i);
            ctxt = bfv.add(ctxt, _tmp);
        }

        std::vector<int64_t> retVec = bfv.decrypt(ctxt)->GetPackedValue();

        for (int i = 0; i < 16; i++) {
            std::cout << retVec[i] << " ";
        }        
        std::cout << std::endl;
    }

    // Test 2
    {
        HE bfv("BFV", 65537, 20);        
        std::vector<int64_t> msgVec = {0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0};
        auto ptxt = bfv.packing(msgVec);
        auto ctxt = bfv.encrypt(ptxt);
        int32_t kVal = 4;
        int32_t numPack = 2;

        Ciphertext<DCRTPoly> _tmp;

        for (int i = numPack; i < kVal; i *= 2 ) {
            _tmp = bfv.rotate(ctxt, i);
            ctxt = bfv.add(ctxt, _tmp);
        }

        std::vector<int64_t> retVec = bfv.decrypt(ctxt)->GetPackedValue();

        for (int i = 0; i < 16; i++) {
            std::cout << retVec[i] << " ";
        }        
        std::cout << std::endl;
    }


}

// Test code for basic OPs
void testBasicOPs() {
    std::cout << "<<< Test for Basic Operations >>>" << std::endl;

    HE bfv("BFV", 65537, 20);

    // Test 1. Addition
    {   
        std::cout << "<<< Addition Test >>>" << std::endl;
        Ciphertext<DCRTPoly> ct1, ct2, _ct;
        Plaintext pt1, pt2;
        std::vector<int64_t> msg1(1<<15, 42);
        std::vector<int64_t> msg2(1<<15, 36);
        pt1 = bfv.packing(msg1);
        pt2 = bfv.packing(msg2);
        ct1 = bfv.encrypt(pt1);
        ct2 = bfv.encrypt(pt2);

        auto t1 = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < 1000; i++) {
            _ct = bfv.add(ct1, ct2);
        }
        auto t2 = std::chrono::high_resolution_clock::now();
        double timeSec = std::chrono::duration<double>(t2 - t1).count();
        std::cout << "Done! (1000its) Time Elapsed: " << timeSec << "s" << std::endl;
    }
    // Test 2
    {   
        std::cout << "<<< Scalar Multiplication Test >>>" << std::endl;
        Ciphertext<DCRTPoly> ct1, _ct;
        Plaintext pt1, pt2;
        std::vector<int64_t> msg1(1<<15, 42);
        std::vector<int64_t> msg2(1<<15, 36);
        pt1 = bfv.packing(msg1);
        pt2 = bfv.packing(msg2);
        ct1 = bfv.encrypt(pt1);

        auto t1 = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < 1000; i++) {
            _ct = bfv.mult(ct1, pt2);
        }
        auto t2 = std::chrono::high_resolution_clock::now();
        double timeSec = std::chrono::duration<double>(t2 - t1).count();
        std::cout << "Done! (1000its) Time Elapsed: " << timeSec << "s" << std::endl;
    }
    // Test 3
    {   
        std::cout << "<<< Multiplication Test >>>" << std::endl;
        Ciphertext<DCRTPoly> ct1, ct2, _ct;
        Plaintext pt1, pt2;
        std::vector<int64_t> msg1(1<<15, 42);
        std::vector<int64_t> msg2(1<<15, 36);
        pt1 = bfv.packing(msg1);
        pt2 = bfv.packing(msg2);
        ct1 = bfv.encrypt(pt1);
        ct2 = bfv.encrypt(pt2);

        auto t1 = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < 1000; i++) {
            _ct = bfv.mult(ct1, ct2);
        }
        auto t2 = std::chrono::high_resolution_clock::now();
        double timeSec = std::chrono::duration<double>(t2 - t1).count();
        std::cout << "Done! (1000its) Time Elapsed: " << timeSec << "s" << std::endl;
    }

    // Test 4
    {   
        std::cout << "<<< Packing Test >>>" << std::endl;
        Plaintext _pt;
        std::vector<int64_t> msg1(1<<15, 42);

        auto t1 = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < 1000; i++) {
            _pt = bfv.packing(msg1);
        }
        auto t2 = std::chrono::high_resolution_clock::now();
        double timeSec = std::chrono::duration<double>(t2 - t1).count();
        std::cout << "Done! (1000its) Time Elapsed: " << timeSec << "s" << std::endl;
    }
}

void testProbNPC(int k) {
    std::cout << "<< Test Code for Exact and Probabilistic NPCs" << std::endl;
    HE bfv("BFV", 65537, 20);  

    // Test 1
    {
        std::cout << "Test 1: Compute Exact NPC" << std::endl;        
        std::vector<Ciphertext<DCRTPoly>> ctxts;
        Plaintext _tmpPtxt; Ciphertext<DCRTPoly> _tmpCtxt;        
        std::vector<int64_t> msgAlpha(1<<15, 3);
        Plaintext ptAlpha = bfv.packing(msgAlpha);

        for (int i = 0; i < k; i++) {
            std::vector<int64_t> msgVec(1<<15, 42);
            msgVec[3] = 0;
            _tmpPtxt = bfv.packing(msgVec);
            _tmpCtxt = bfv.encrypt(_tmpPtxt);
            ctxts.push_back(_tmpCtxt);
        }

        // Run NPCs
        auto t1 = std::chrono::high_resolution_clock::now();
        auto ret = compNPC(bfv, ctxts, ptAlpha);
        auto t2 = std::chrono::high_resolution_clock::now();
        double timeSec = std::chrono::duration<double>(t2 - t1).count();        
        std::cout << "Done! Time Elapsed: " << timeSec << "s" << std::endl;
        std::cout << "<<< 4th Result Should be 0 >>>" << std::endl;        
        auto retVec = bfv.decrypt(ret)->GetPackedValue();
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;
    }   

    // Test 2
    {
        std::cout << "Test 2: Compute Probabilistic NPC" << std::endl;      
        std::vector<Ciphertext<DCRTPoly>> ctxts;
        Plaintext _tmpPtxt; Ciphertext<DCRTPoly> _tmpCtxt;        
        std::vector<int64_t> msgAlpha(1<<15, 3);
        Plaintext ptAlpha = bfv.packing(msgAlpha);

        for (int i = 0; i < k; i++) {
            std::vector<int64_t> msgVec(1<<15, 42);
            msgVec[3] = 0;
            _tmpPtxt = bfv.packing(msgVec);
            _tmpCtxt = bfv.encrypt(_tmpPtxt);
            ctxts.push_back(_tmpCtxt);
        }

        // Run NPCs
        int numRand = 8;
        auto t1 = std::chrono::high_resolution_clock::now();
        auto ret = compProbNPC(bfv, ctxts, ptAlpha, numRand);
        auto t2 = std::chrono::high_resolution_clock::now();
        double timeSec = std::chrono::duration<double>(t2 - t1).count();        
        std::cout << "Done! Time Elapsed: " << timeSec << "s" << std::endl;
        std::cout << "<<< 4th Result Should be 0 >>>" << std::endl;        
        auto retVec = bfv.decrypt(ret)->GetPackedValue();
        for (int i = 0; i < 10; i++) {
            std::cout << retVec[i] << " ";
        }
        std::cout << std::endl;
    }       
}

void testAgg(int numParties) {
    std::cout << "<< Test Code for Measuring Aggregation Cost" << std::endl;
    HE bfv("BFV", 65537, 20);  
    Ciphertext<DCRTPoly> _tmp, __tmp, ret;
    Plaintext _ptxt;
    std::vector<int64_t> msgVec(bfv.ringDim, 42);

    // Prepare Dataset    
    std::vector<Ciphertext<DCRTPoly>> ctVec(numParties);
    for (int i = 0; i < numParties; i++) {        
        _ptxt = bfv.packing(msgVec);
        _tmp = bfv.encrypt(_ptxt);
        __tmp = bfv.compress(_tmp);
        ctVec[i] = __tmp;
    }

    // Do Aggregation
    auto t1 = std::chrono::high_resolution_clock::now();
    ret = bfv.addmany(ctVec);
    auto t2 = std::chrono::high_resolution_clock::now();
    double timeSec = std::chrono::duration<double>(t2-t1).count();
    std::cout << "Done! Time Elapsed: " << timeSec << "s" << std::endl;
}


// Test code for all backends
void testAllBackends(int k, int numParties) {
    // More test functions will be added.
    testEncoding();
    testVAFs();
    testNPC();
    testRotAdd();
    testBasicOPs();
    testProbNPC(k);
    testAgg(numParties);
}