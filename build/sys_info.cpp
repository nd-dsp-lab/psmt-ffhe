#include <sys/sysinfo.h>
#include <iostream>

int main() {
    struct sysinfo info;
    if (sysinfo(&info) == 0) {
        std::cout << "Total RAM: " << info.totalram / (1024 * 1024) << " MB\n";
        std::cout << "Free RAM: " << info.freeram / (1024 * 1024) << " MB\n";
        std::cout << "Available RAM: " << info.freeram / (1024 * 1024) << " MB\n";
    } else {
        std::cerr << "Failed to get memory info\n";
    }
    return 0;
}