# MatrixMultiplication
Just a little playground, to test and try the benefits of Running Calculations on CPU or GPU with multiple threads.

Compared Runtimes:

Matrix size: 1440x1440 <br>
Threads: 24


## Java:

Single: 7.769 s <br>
Threads: 1.124 s

## C++

Single:  2.21483 s <br>
Threads: 0.460356 s

## CUDA

Threaded: 21.499 ms

## Python

Single: 1177.62 s <br>
Threaded: 73.42s

## Kotlin

Single: 7.061s <br>
Threaded: 1.15s
