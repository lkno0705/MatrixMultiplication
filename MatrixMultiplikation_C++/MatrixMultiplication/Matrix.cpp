#include <iostream>
#include <stdlib.h>
#include "Matrix.h"

using namespace Matrix;


	void matrix::createRandomMatrix() {
		for (int r = 0; r < m; r++) {

			for (int c = 0; c < n; c++) {
				matrix[r][c] = rand() % 10;
			}
		}
	}

	void matrix::createEmptyMatrix() {
		for (int r = 0; r < m; r++) {
			for (int c = 0; c < n; c++) {
				matrix[r][c] = 0;
			}
		}
	}

	void matrix::print() {
		for (int r = 0; r < m; r++) {
			for (int c = 0; c < n; c++) {
				std::cout << matrix[r][c] << " ";
			}
			std::cout << "\n";
		}
		std::cout << "\n";
	}