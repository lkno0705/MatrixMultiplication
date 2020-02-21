#pragma once
#include <vector>

namespace Matrix {
	class matrix {
	public:
		const static int n = 2840;
		const static int m = 2840;
		std::vector<std::vector<long>> matrix;
		void createRandomMatrix();
		void print();
		void createEmptyMatrix();
	};
}