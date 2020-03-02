import Matrix
import multiprocessing
import time

THREADS = 24

def matrixMult(A, B, C, upperbound, lowerbound=0):
    b = B.matrix # 15% speedup
    a_matrix = A.matrix # 1% speedup
    c_matrix = C.matrix # 1% speedup
    j_range = A.n # 1% speedup
    k_range = B.n # 1% speedup
    for i in range(lowerbound, upperbound):
        a = a_matrix[i] # 15% speedup
        c = c_matrix[i] # 5% speedup
        for k in range(k_range):
            summed = 0 # 10% speedup
            for j in range(j_range):
                summed += a[j] * b[j][k]
            c[k] = summed

def threaded(A, B, C):
    threads = []
    step = int(A.m / THREADS)

    for i in range(THREADS):
        if i == (THREADS - 1):
            threads.append(multiprocessing.Process(target=matrixMult, args=(A, B, C,A.m, i*step)))
        else:
            threads.append(multiprocessing.Process(target=matrixMult, args=(A, B, C, ((i+1)*step), i*step)))
        threads[i].start()

    for i in range(THREADS):
        threads[i].join()

def main():
    m = 1440
    n = 1440

    A = Matrix.Matrix(m, n)
    B = Matrix.Matrix(m, n)
    CWOT = Matrix.Matrix(m, n)
    CWT = Matrix.Matrix(m, n)

    A.createRandomMatrix()
    B.createRandomMatrix()
    CWT.createEmptyMatrix()
    CWOT.createRandomMatrix()

    startWOT = time.time()
    matrixMult(A, B, CWOT, m)
    stopWOT = time.time()
    print("Duration WOT: ", stopWOT-startWOT, " s")

    start = time.time()
    threaded(A, B, CWT)
    stop = time.time()
    print("Duration WT: ", stop-start, " s")


if __name__ == '__main__':
    main()