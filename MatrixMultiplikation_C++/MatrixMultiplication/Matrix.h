#pragma once
#include <vector>

namespace Matrix {
	class matrix {
	public:
		int n;
		int m;
		std::vector<std::vector<long>> matrix;
		void createRandomMatrix(int m, int n);
		void print();
	};
}