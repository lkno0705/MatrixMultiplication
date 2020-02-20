#include <iostream>
#include <stdlib.h>
#include "Matrix.h"

using namespace Matrix;


	void matrix::createRandomMatrix(int lm, int ln) {
		m = lm;
		n = ln;

		for (int r = 0; r < m; r++) {
			matrix.push_back({});

			for (int c = 0; c < n; c++) {
				matrix[r].push_back(rand() % 10);
			}
		}
	}

	void matrix::print() {
		for (int r = 0; r < matrix.size(); r++) {
			for (int c = 0; c < matrix[r].size(); c++) {
				std::cout << matrix[r][c] << " ";
			}
			std::cout << "\n";
		}
		std::cout << "\n";
	}