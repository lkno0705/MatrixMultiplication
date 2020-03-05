# MatrixMultiplication
Just a little playground, to test and try the benefits of Running Calculations on CPU or GPU with multiple threads.

Compared Runtimes:

Matrix size: 1440x1440 <br>
Threads: 24


## Java:

### Type int
Single: 7.769s <br>
Threaded: 1.124s

### Type float
Single: 6.837s <br>
Threaded: 1.225s

## C++

Single:  2.21483s <br>
Threaded: 0.460356s

## CUDA

Threaded: 21.499 ms

## Python

Single: 230.283s <br>
Threaded: 17.304s

## Kotlin

Single: 6.5s <br>
Threaded: 1.15s


## Rust

Single: 2.103s <br>
Threaded: 0.496s

## C#
Single: 3.16s <br>
Threaded: 0.515s

## C

Single: 2.177s <br>
Threaded: 0.456s


## GO

Single: 2.556s <br>
Threaded: 0.4934s

## x64 NASM

Single: 2.363s <br>
Threaded: 0.507s
