# abap-zmatrix
Implementation of matrix multiplication in ABAP.

## Reports
**Z_MATRIXMULT** Computes the product of two matrices filled with random numbers between 1 and 10.  
**Z_MATRIXMULT_PAR** Computes the product of two matrices filled with random numbers between 1 and 10 *using parallel processing*.  

##  Function Group
**ZFG_MATRIX** Contains function module for parallel processing.  

## Function Module
**ZFM_CALC_VALUES** Computes the product of two matrices with parallel processing, compatible with RFCs.  

## Classes
**ZCL_MATRIX** Contains the functionality of a matrix for processing in *one* work process.  
**ZCL_MATRIX_PAR** Contains the functionality of a matrix for parallel processing in *multiple* work process.  

## DDIC Elements
**ZSMATRIX** Structure for table to hold the values of a matrix.  
**ZTMATRIX** Hashed table to hold the values of a matrix.  
**ZTMATRIX_PAR** Sorted table to hold the values of a matrix, compatible with RFCs.  
