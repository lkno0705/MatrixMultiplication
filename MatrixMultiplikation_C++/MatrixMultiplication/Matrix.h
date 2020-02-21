#pragma once
#include <vector>

namespace Matrix {
	class matrix {
	public:
		const static int n = 10;
		const static int m = 10;
		long *matrix;
		void createRandomMatrix();
		void print();
		void createEmptyMatrix();
		void deleteMatrix();
	};
}