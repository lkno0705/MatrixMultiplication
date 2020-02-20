#pragma once
#include <vector>

namespace Matrix {
	class matrix {
	public:
		const static int n = 1440;
		const static int m = 1440;
		long matrix[1440][1440];
		void createRandomMatrix();
		void print();
		void createEmptyMatrix();
	};
}