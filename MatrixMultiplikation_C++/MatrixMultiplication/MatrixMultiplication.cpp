// MatrixMultiplication.cpp : Diese Datei enthält die Funktion "main". Hier beginnt und endet die Ausführung des Programms.
//
#include "Matrix.h"
#include <iostream>

void a(Matrix::matrix* matrixPtr) {
    matrixPtr->createRandomMatrix();
    return;
}

int main()
{
    std::cout << "Hello World!\n";

    Matrix::matrix matrixA;
    Matrix::matrix matrixB;
    Matrix::matrix matrixC;
	Matrix::matrix *matrixCPtr;

    matrixA.createRandomMatrix();
    matrixB.createRandomMatrix();
	matrixCPtr = &matrixC; //Pointer verweist auf den Speicher einer anderen Variable

	a(matrixCPtr);

    matrixA.print();
    matrixB.print();
	matrixC.print();
    

}

// Programm ausführen: STRG+F5 oder "Debuggen" > Menü "Ohne Debuggen starten"
// Programm debuggen: F5 oder "Debuggen" > Menü "Debuggen starten"

// Tipps für den Einstieg: 
//   1. Verwenden Sie das Projektmappen-Explorer-Fenster zum Hinzufügen/Verwalten von Dateien.
//   2. Verwenden Sie das Team Explorer-Fenster zum Herstellen einer Verbindung mit der Quellcodeverwaltung.
//   3. Verwenden Sie das Ausgabefenster, um die Buildausgabe und andere Nachrichten anzuzeigen.
//   4. Verwenden Sie das Fenster "Fehlerliste", um Fehler anzuzeigen.
//   5. Wechseln Sie zu "Projekt" > "Neues Element hinzufügen", um neue Codedateien zu erstellen, bzw. zu "Projekt" > "Vorhandenes Element hinzufügen", um dem Projekt vorhandene Codedateien hinzuzufügen.
//   6. Um dieses Projekt später erneut zu öffnen, wechseln Sie zu "Datei" > "Öffnen" > "Projekt", und wählen Sie die SLN-Datei aus.
