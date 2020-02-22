#pragma once
#include <vector>

namespace Matrix {
	class matrix {
	public:
		const static int n = 1440;
		const static int m = 1440;
		float *matrix;
		void createRandomMatrix();
		void print();
		void createEmptyMatrix();
		void deleteMatrix();
	};
}