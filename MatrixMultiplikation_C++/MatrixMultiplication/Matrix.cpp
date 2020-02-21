#include <iostream>
#include <stdlib.h>
#include "Matrix.h"

using namespace Matrix;

// 0,0 0,1 0,2
// 1,0 1,1 1,2
// => 0, 1, 2, 3, 4, 5
// => numberOfColumns * currentRow + currentColumn

	void matrix::createRandomMatrix() {
		matrix = new long[m*n];
		for (int r = 0; r < m; r++) {
			for (int c = 0; c < n; c++) {
				matrix[n*r+c] = rand() % 10;
			}
		}
	}

	void matrix::createEmptyMatrix() {
		matrix = new long[m*n];
		for (int r = 0; r < m; r++) {
			for (int c = 0; c < n; c++) {
				matrix[n * r + c] = 0;
			}
		}
	}

	void matrix::print() {
		for (int r = 0; r < m; r++) {
			for (int c = 0; c < n; c++) {
				std::cout << matrix[n * r + c] << " ";
			}
			std::cout << "\n";
		}
		std::cout << "\n";
	}

	void matrix::deleteMatrix() {
		delete[] matrix;
	}