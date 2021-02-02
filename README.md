# MatrixMultiplication
Just a little playground, to test and try the benefits of Running Calculations on CPU or GPU with multiple threads.

## System stats for the compared run:
Default matrix size: 1440x1440 <br>
Thread count: 24

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

## SIMD
Single:  0.5412s <br>
Threaded: 0.1225s

## CUDA
Single: - <br>
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
Single: 0.621s <br>
Threaded: 0.100s

## PHP
Single: 160.47s <br>
Threaded: -

## Julia 
Single: 3.171s <br>
Threaded: 0.576

## Excel VBA (Matrix size: 340x340)
Single: 936s <br>
Threaded: - (Not supported)

## XSLT (Matrix size: 340x340)
Firefox: 1 801s <br>
Chrome: 4 101s

## F#
Single: 2.923s <br>
Threaded: 0.518s

## JS
Single: 14.25618s <br>
Threaded: -

## OpenCL
Single: To be tested <br>
Threaded: To be tested

## SQLite (Matrix size: 340x340)
Single: 41.61s <br>
Threaded: -

## TCL
Single: - <br>
Threaded: 170,69s

## Lua
Single: To be tested <br>
Threaded: To be tested

## Zig
Single: To be tested <br>
Threaded: To be tested
