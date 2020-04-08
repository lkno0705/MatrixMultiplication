#include <chrono>
#include <iostream>

#include "matmul.hpp"

int size = 1440;  //Side length of quadratic matrix.

float* createRandomMatrix(int width, int height) {
    srand(time(NULL));
    float* matrix = new float[width * height];
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            matrix[x + width * y] = rand() % 10;
        }
    }
    return matrix;
}

int main() {
    std::cout << "Generating matrices"
              << "\n";
    float* matA = createRandomMatrix(size, size);
    float* matB = createRandomMatrix(size, size);
    float* matC;

    std::cout << "Starting execution. This includes compilation of the kernel, etc. This does not have to be done everytime so you might ignore the total execution time"
              << "\n";
    std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
    MatMul(matA, matB, matC, size, size, size);
    int timeInMs = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now() - start).count();
    std::cout << "Finished execution of everything in : " << timeInMs << "ms"
              << "\n";

    delete matA;
    delete matB;
    delete matC;
}