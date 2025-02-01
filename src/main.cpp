#include "tests.h"

int main() {
    // testAllBackends();
    // testBasicOPs();
    // testProbNPC(512);
    // testAgg(512);
    testFullProtocol(
        20,         // numItem
        8,          // lenData  
        1,          // numPack
        8,          // numAgg
        3,          // alpha
        "CPI"       // interType
    );
    return 0;
}

