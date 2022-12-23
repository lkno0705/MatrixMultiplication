Attribute VB_Name = "MatrixMultiplication"
Option Explicit

Sub MatrixMultiplication()
    Const aM = 1440 - 1
    Const aN = 1440 - 1
    Const bN = 1440 - 1
    
    Dim i As Long, j As Long, k As Long, start As Double
    ' "Single" corresponds to "float" in C:
    Dim matrixA(aM, aN) As Single, matrixB(aN, bN) As Single, matrixC(aM, bN) As Single
    
    For i = 0 To aM
        For k = 0 To aN
            matrixA(i, k) = 1 + Rnd * (10 - 1 + 1)
        Next k
    Next i
    For i = 0 To aN
        For k = 0 To bN
            matrixB(i, k) = 1 + Rnd * (10 - 1 + 1)
        Next k
    Next i
    
    start = Timer
    For i = 0 To aM
        For k = 0 To bN
            matrixC(i, k) = 0
            For j = 0 To aN
                matrixC(i, k) = matrixC(i, k) + matrixA(i, j) * matrixB(j, k)
            Next j
        Next k
    Next i
    Cells(10, 3) = Timer - start
End Sub
