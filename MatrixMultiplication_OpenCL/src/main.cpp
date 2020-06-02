#include <chrono>
#include <iostream>

#include "matmul.hpp"

int size = 1440; //Side length of quadratic matrix.

//Should divide size evenly. Should also not be too large. Most modern GPUs support 1024 as maximum size here.
//On my Vega56 a size of 32 and up are best. Very small values like 1 reduce performance because we do not use the GPU to its fullest extend.
int localWorkGroupSize = 32;
float* createRandomMatrix(int width, int height) {
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
    srand(time(NULL));
    float* matA = createRandomMatrix(size, size);
    float* matB = createRandomMatrix(size, size);
    float* matC = new float[size * size];

    std::cout << "Starting execution. This includes compilation of the kernel, etc. Some of this does not have to be done everytime so you might ignore the total execution time"
              << "\n";
    std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
    MatMul(matA, matB, matC, size, localWorkGroupSize);
    int timeInMs = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now() - start).count();
    std::cout << "Finished execution of everything in : " << timeInMs << "ms"
              << "\n";

    delete[] matA;
    delete[] matB;
    delete[] matC;
}