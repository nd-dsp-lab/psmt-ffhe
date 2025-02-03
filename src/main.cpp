#include "tests.h"

int main() {
    // testAllBackends();
    // testBasicOPs();
    // testProbNPC(512);
    // testAgg(512);
    testFullProtocol(
        23,         // numItem
        1,          // lenData  
        1,          // numPack
        8,          // numAgg
        3,          // alpha
        "CI"       // interType
    );
    return 0;
}

