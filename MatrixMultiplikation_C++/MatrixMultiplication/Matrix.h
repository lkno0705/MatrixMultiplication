#pragma once
namespace Matrix {
	class matrix {
	public:
		const int n = 10;
		const int m = 10;
		int matrix[10][10];
		void createRandomMatrix();
		void print();
	};
}