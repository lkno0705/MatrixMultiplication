// MatrixMultiplication.cpp : Diese Datei enthält die Funktion "main". Hier beginnt und endet die Ausführung des Programms.
//
#include "Matrix.h"
#include <iostream>
#include <chrono>
#include <thread>

using namespace std::chrono;

void matrixmult(Matrix::matrix* Cptr, Matrix::matrix* Aptr, Matrix::matrix* Bptr,int upperbound,int lowerbound = 0) {

    for (int i = lowerbound; i < upperbound; i++){

        for (int k = 0; k < Bptr->n; k++){

            for (int j = 0; j < Aptr->n; j++){
                Cptr->matrix[i][k] += Aptr->matrix[i][j] * Bptr->matrix[j][k];
                //std::cout << "running..."<<i;
            }
        }
    }
    return;
}

void threadedmult(Matrix::matrix* Cptr, Matrix::matrix* Aptr, Matrix::matrix* Bptr) {
    std::thread threadarr[8];
    int step = Aptr->m / 8;
    int upperbound;
    for (int i = 0; i < 8; i++)
    {
        if (i == 7)
        {
            upperbound = Aptr->m;
        }
        else
        {
            upperbound = (i + 1) * step;
        }
        threadarr[i] = std::thread(matrixmult, Cptr, Aptr, Bptr, upperbound, (i*step));
    }
    std::cout << "\n[*] Threads running...";
    for (int i = 0; i < 8; i++)
    {
        threadarr[i].join();
    }
    std::cout << "\n[+] Threads completed!";
}

int main()
{
    std::cout << "Matrix multiplication\n";
    /*time_t startWOT, stopWOT, startWT, stopWT;*/

    Matrix::matrix matrixA;
    Matrix::matrix matrixB;
    Matrix::matrix matrixCWT;
    Matrix::matrix matrixCWOT;
	Matrix::matrix *matrixCWOTPtr = &matrixCWOT; //Pointer verweist auf den Speicher einer anderen Variable
    Matrix::matrix *matrixAPtr = &matrixA;
    Matrix::matrix *matrixBPtr = &matrixB;
    Matrix::matrix* matrixCWTPtr = &matrixCWT;

    matrixA.createRandomMatrix();
    matrixB.createRandomMatrix();
    matrixCWT.createEmptyMatrix();
    matrixCWOT.createEmptyMatrix();

    std::cout << "\n[+] Single Core calculation started. \n[*] Calculating...";
    auto startWOT = high_resolution_clock::now();
	matrixmult(matrixCWOTPtr, matrixAPtr, matrixBPtr, matrixAPtr->m);
    auto stopWOT = high_resolution_clock::now();
    //double durationWOT = double(stopWOT - startWOT);
    std::cout << "\n[+] Single Core calculation finished \n[+] Duration: " << duration<double> (stopWOT - startWOT).count() << " seconds";

    std::cout << "\n[+] Multithreaded calculation started. \n[*] Calculating...";
    auto startWT = high_resolution_clock::now();
    threadedmult(matrixCWTPtr, matrixAPtr, matrixBPtr);
    auto stopWT = high_resolution_clock::now();
    std::cout << "\n[+] Multithreaded calculation finished \n[+] Duration: " << duration<double>(stopWT - startWT).count() << " seconds";

    //matrixA.print();
    //matrixB.print();
    //matrixCWT.print();
    

}
