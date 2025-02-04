#include <iostream>
#include <cstdlib>  // for std::atoi
#include <string>
#include <cctype>   // for std::isdigit
#include "tests.h"

// Helper function to check if a string is a valid positive integer
bool isValidNumber(const std::string& str) {
    if (str.empty()) return false;
    for (char c : str) {
        if (!std::isdigit(c)) return false;
    }
    return true;
}

int main(int argc, char* argv[]) {
    // Default values
    int numItem = 23;
    int lenData = 1;
    int numPack = 1;
    int numAgg = 8;
    int alpha = 3;
    std::string interType = "CI";

    // Validate and parse command-line arguments
    if (argc > 1) {
        if (!isValidNumber(argv[1])) {
            std::cerr << "Error: numItem must be a positive integer.\n";
            return 1;
        }
        numItem = std::atoi(argv[1]);
    }

    if (argc > 2) {
        if (!isValidNumber(argv[2])) {
            std::cerr << "Error: lenData must be a positive integer.\n";
            return 1;
        }
        lenData = std::atoi(argv[2]);
    }

    if (argc > 3) {
        if (!isValidNumber(argv[3])) {
            std::cerr << "Error: numPack must be a positive integer.\n";
            return 1;
        }
        numPack = std::atoi(argv[3]);
    }

    if (argc > 4) {
        if (!isValidNumber(argv[4])) {
            std::cerr << "Error: numAgg must be a positive integer.\n";
            return 1;
        }
        numAgg = std::atoi(argv[4]);
    }

    if (argc > 5) {
        if (!isValidNumber(argv[5])) {
            std::cerr << "Error: alpha must be a positive integer.\n";
            return 1;
        }
        alpha = std::atoi(argv[5]);
    }

    if (argc > 6) {
        interType = argv[6];
        if (interType.empty()) {
            std::cerr << "Error: interType must be a non-empty string.\n";
            return 1;
        }
    }

    std::cout << "Running testFullProtocol with:\n";
    std::cout << "numItem = " << numItem << "\n";
    std::cout << "lenData = " << lenData << "\n";
    std::cout << "numPack = " << numPack << "\n";
    std::cout << "numAgg = " << numAgg << "\n";
    std::cout << "alpha = " << alpha << "\n";
    std::cout << "interType = " << interType << "\n";

    // testAllBackends();
    // testBasicOPs();
    // testProbNPC(512);
    // testAgg(512);

    testFullProtocol(numItem, lenData, numPack, numAgg, alpha, interType);

    return 0;
}
