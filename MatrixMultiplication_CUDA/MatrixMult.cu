#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <chrono>

using namespace std::chrono;

// 0,0 0,1 0,2
// 1,0 1,1 1,2
// => 0, 1, 2, 3, 4, 5
// => numberOfColumns * currentRow + currentColumn

__global__ void matrixmult(float* Cptr, float* Aptr, float* Bptr, int m, int n) {
	// blockDim.x = number of threads in the current Block
	// threadIdx.x = index of current thread
	int Cidx = blockIdx.x * blockDim.x + threadIdx.x; // ^= n * i + k
	int i = Cidx / n;
	int k = Cidx - n * i;
	if (n * m > Cidx) {
		for (int j = 0; j < n; j++) {
			Cptr[Cidx] += Aptr[n * i + j] * Bptr[n * j + k];
		}
	}
}

float* createRandomMatrix(float *matrix, int m, int n) {
	matrix = new float[m * n];
	for (int r = 0; r < m; r++) {
		for (int c = 0; c < n; c++) {
			matrix[n * r + c] = static_cast <float> (rand() % 10) / 1.0;
		}
	}
	return matrix;
}

float* createEmptyMatrix(float* matrix, int m, int n) {
	matrix = new float[m * n];
	for (int r = 0; r < m; r++) {
		for (int c = 0; c < n; c++) {
			matrix[n * r + c] = 0.0;
		}
	}
	return matrix;
}

void print(float* matrix, int m, int n) {
	for (int r = 0; r < m; r++) {
		for (int c = 0; c < n; c++) {
			std::cout << matrix[n * r + c] << " ";
		}
		std::cout << "\n";
	}
	std::cout << "\n";
}

void deleteMatrix(float* matrix) {
	delete[] matrix;
}

int main() {

	int m = 1440;
	int n = 1440;
	int block_size = 512;
	
	//float pointer initialisieren und Speicher für den Array reservieren
	float* matrixA = (float*)malloc(m * n);
	float* matrixB = (float*)malloc(m * n);
	float* h_matrixC = (float*)malloc(m * n);

	float* d_matrixA;
	float* d_matrixB;
	float* d_matrixC;

	/*lowerbound = 0;
	upperbound = m;*/
	matrixA = createRandomMatrix(matrixA, m, n);
	matrixB = createRandomMatrix(matrixB, m, n);
	h_matrixC = createEmptyMatrix(h_matrixC, m, n);

	//Allocate space for device copies in device memory
	cudaMalloc(&d_matrixA, (m * n) * sizeof(float));
	cudaMalloc(&d_matrixB, (m * n) * sizeof(float));
	cudaMalloc(&d_matrixC, (m * n) * sizeof(float));
	//cudaMalloc(&d_lowerbound, sizeof(int));
	//cudaMalloc(&d_upperbound, sizeof(int));

	//print(matrixA, m, n);
	//print(matrixB, m, n);

	cudaMemcpy(d_matrixA, matrixA, (m * n) * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_matrixB, matrixB, (m * n) * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_matrixC, h_matrixC, (m * n) * sizeof(float), cudaMemcpyHostToDevice);
	//cudaMemcpy(d_lowerbound, &lowerbound, sizeof(int), cudaMemcpyHostToDevice);
	//cudaMemcpy(d_upperbound, &upperbound, sizeof(int), cudaMemcpyHostToDevice);

	int Blocks = ((n*m) + block_size - 1) / block_size;
	std::cout << "[+] Calculation started with " << (Blocks * block_size) << " Threads";
	auto start = high_resolution_clock::now();
	//Run Kernel on GPU
	matrixmult <<<Blocks, block_size >>> (d_matrixC, d_matrixA, d_matrixB, m, n);

	//Wait for GPU to finish
	cudaDeviceSynchronize();
	auto stop = high_resolution_clock::now();

	cudaMemcpy(h_matrixC, d_matrixC, (m * n) * sizeof(float), cudaMemcpyDeviceToHost);
	std::cout << "\n[+] Multithreaded calculation finished \n[+] Duration: " << duration<double>(stop - start).count() << " seconds";

	/*print(h_matrixC, m, n);*/

	//Free memory
	cudaFree(d_matrixA);
	cudaFree(d_matrixB);
	cudaFree(d_matrixC);
	
	delete[] matrixA;
	delete[] matrixB;
	delete[] h_matrixC;
}