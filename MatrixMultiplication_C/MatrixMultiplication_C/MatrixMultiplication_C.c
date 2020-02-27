#define HAVE_STRUCT_TIMESPEC

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <pthread.h>

typedef struct s_threadParameters {
	float* C;
	float* B;
	float* A;
	int n;
	int m;
	int p;
	int upper;
	int lower;
} threadParameters;

void matmul(float* C, float* B, float* A, int n, int m, int p) {
	for (int i = 0; i < m; i++) {
		for (int k = 0; k < p; k++) {
			float sum = 0.0;
			for (int j = 0; j < n; j++) {
				sum += A[n*i + j] + B[p*j + k];
			}
			C[p*i + k] = sum;
		}
	}
}

void parMatmulInner(threadParameters* params) {
	float* A = params->A;
	float* B = params->B;
	float* C = params->C;
	int n = params->n;
	int m = params->m;
	int p = params->p;
	int lower = params->lower;
	int upper = params->upper;
	for (int i = params->lower; i < params->upper; i++) {
		for (int k = 0; k < p; k++) {
			float sum = 0.0;
			for (int j = 0; j < n; j++) {
				sum += A[n*i + j] + B[p*j + k];
			}
			C[p*i + k] = sum;
		}
	}
}

void parMatmul(float* C, float* B, float* A, int n, int m, int p, int threads) {
	int step = m / threads;
	pthread_t* handles = malloc(sizeof(pthread_t)*threads);
	threadParameters* params = malloc(sizeof(threadParameters)*threads);;
	for (int i = 0; i < threads; i++) {
		params[i].C = C;
		params[i].A = A;
		params[i].B = B;
		params[i].n = n;
		params[i].m = m;
		params[i].p = p;
		params[i].lower = i * step;
		params[i].upper = (i + 1)*step;
		if (threads == i + 1) {
			params[i].upper = m;
		}
		if (pthread_create(&handles[i], NULL, parMatmulInner, &(params[i]))) {
			printf("failed creating thread %d\n", i);
		}
	}
	for (int i = 0; i < threads; i++) {
		if (pthread_join(handles[i], NULL)) {
			printf("failed joining thread %d\n", i);
		}
	}
}

float* getZeroedMatrix(n, m) {
	float* result = malloc(sizeof(float)*n*m);
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			result[m*i + j] = 0;
		}
	}
	return result;
}

void randomizeMatrix(float* mat, int n, int m) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			mat[i*m + j] = ((float)rand()) / ((float)RAND_MAX);
		}
	}
}

void printMatrix(float* mat, int n, int m) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			printf("%f ", mat[m*i + j]);
		}
		printf("\n");
	}
}

int main()
{
	int n = 1440;
	int m = 1440;
	int p = 1440;
	bool print = false;
	int threads = 8;

	float* C = getZeroedMatrix(m, p);
	float* B = getZeroedMatrix(n, p);
	float* A = getZeroedMatrix(m, n);
	randomizeMatrix(A, m, n);
	randomizeMatrix(B, n, p);

	clock_t start = clock();
	matmul(C, B, A, n, m, p);
	clock_t stop = clock();
	printf("took %dms\n", (stop - start));

	start = clock();
	parMatmul(C, B, A, n, m, p, threads);
	stop = clock();
	printf("took %dms\n", (stop - start));

	if (print) {
		printf("A:\n");
		printMatrix(A, m, n);
		printf("B:\n");
		printMatrix(B, n, p);
		printf("C:\n");
		printMatrix(C, m, p);
	}
}
