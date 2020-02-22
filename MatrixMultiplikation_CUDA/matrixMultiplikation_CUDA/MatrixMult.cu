#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

// 0,0 0,1 0,2
// 1,0 1,1 1,2
// => 0, 1, 2, 3, 4, 5
// => numberOfColumns * currentRow + currentColumn

__global__ void matrixmult(float* Cptr, float* Aptr, float* Bptr, int* m, int* n, int* upperbound, int *lowerbound) {
	for (int i = *lowerbound; i < *upperbound; i++) {
		for (int k = 0; k < *n; k++) {
			for (int j = 0; j < *n; j++) {
				Cptr[*n * i + k] += Aptr[*n * i + j] * Bptr[*n * j + k];
			}
		}
	}
}

float* createRandomMatrix(float *matrix, int m, int n) {
	matrix = new float[m * n];
	for (int r = 0; r < m; r++) {
		for (int c = 0; c < n; c++) {
			matrix[n * r + c] = static_cast <float> (rand() % 10);
		}
	}
	return matrix;
}

float* createEmptyMatrix(float* matrix, int m, int n) {
	matrix = new float[m * n];
	for (int r = 0; r < m; r++) {
		for (int c = 0; c < n; c++) {
			matrix[n * r + c] = 0;
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

	int m;
	int n;
	int upperbound;
	int lowerbound;
	
	float* matrixA;
	float* matrixB;
	float* matrixC;

	float* d_matrixA;
	float* d_matrixB;
	float* d_matrixC;
	int* d_m;
	int* d_n;
	int* d_lowerbound;
	int* d_upperbound;

	//Allocate space for device copies
	cudaMalloc((void**)&d_matrixA, (m * n) * sizeof(float));
	cudaMalloc((void**)&d_matrixB, (m * n) * sizeof(float));
	cudaMalloc((void**)&d_matrixC, (m * n) * sizeof(float));
	cudaMalloc((void**)&d_m, sizeof(int));
	cudaMalloc((void**)&d_n, sizeof(int));
	cudaMalloc((void**)&d_lowerbound, sizeof(int));
	cudaMalloc((void**)&d_upperbound, sizeof(int));

	m = 10;
	n = 10;
	lowerbound = 0;
	upperbound = m;
	matrixA = createRandomMatrix(matrixA, m, n);
	matrixB = createRandomMatrix(matrixB, m, n);
	matrixC = createEmptyMatrix(matrixC, m, n);

	/*print(matrixA, m, n);
	print(matrixB, m, n);*/

	cudaMemcpy(d_matrixA, matrixA, (m * n) * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_matrixB, matrixB, (m * n) * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_matrixC, matrixC, (m * n) * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_m, &m, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_n, &n, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_lowerbound, &lowerbound, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_upperbound, &upperbound, sizeof(int), cudaMemcpyHostToDevice);


	//Run Kernel on GPU
	matrixmult <<<1, 1 >>> (d_matrixC, d_matrixA, d_matrixB, d_m, d_n, d_upperbound, d_lowerbound);

	//Wait for GPU to finish
	cudaDeviceSynchronize();

	/*matrixC = matrixmult(matrixC, matrixA, matrixB, m, n, m);*/
	cudaMemcpy(matrixA, d_matrixA, (m * n) * sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(matrixB, d_matrixB, (m * n) * sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(matrixC, d_matrixC, (m * n) * sizeof(float), cudaMemcpyDeviceToHost);
	/*cudaMemcpy(&m, d_m, sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(&n, d_n, sizeof(int), cudaMemcpyDeviceToHost);*/



	print(matrixC, m, n); //ALWAYS 00000... WHY?!

	//Free memory
	cudaFree(d_matrixA);
	cudaFree(d_matrixB);
	cudaFree(d_matrixC);
	cudaFree(d_m);
	cudaFree(d_n);
	
}