// MatrixMultiplication.cpp : Diese Datei enthält die Funktion "main". Hier beginnt und endet die Ausführung des Programms.
//
#include "Matrix.h"
#include <iostream>
#include <ctime>

void a(Matrix::matrix* Cptr, Matrix::matrix* Aptr, Matrix::matrix* Bptr) {
    
    for (int i = 0; i < Aptr->m; i++){
        Cptr->matrix.push_back({});

        for (int k = 0; k < Bptr->n; k++){
            Cptr->matrix[i].push_back({});

            for (int j = 0; j < Aptr->n; j++){
                Cptr->matrix[i][k] += Aptr->matrix[i][j] * Bptr->matrix[j][k];
                std::cout << "running..."<<i;
            }
        }
    }
    return;
}

int main()
{
    std::cout << "Matrix multiplication\n";

    int mA = 50;
    int nA = 50;
    int mB = nA;
    int nB = 50;
    time_t startWOT, stopWOT;

    Matrix::matrix matrixA;
    Matrix::matrix matrixB;
    Matrix::matrix matrixC;
	Matrix::matrix *matrixCPtr = &matrixC; //Pointer verweist auf den Speicher einer anderen Variable
    Matrix::matrix *matrixAPtr = &matrixA;
    Matrix::matrix* matrixBPtr = &matrixB;

    matrixA.createRandomMatrix(mA, nA);
    matrixB.createRandomMatrix(mB, nB);

    time(&startWOT);
	a(matrixCPtr, matrixAPtr, matrixBPtr);
    time(&stopWOT);
    double durationWOT = double(stopWOT - startWOT);
    std::cout << durationWOT << " seconds";

    //   matrixA.print();
    //   matrixB.print();
    //   matrixC.print();
    

}
