import Matrix
import multiprocessing
import time

def matrixMult(A, B, C, upperbound, lowerbound=0):
    #print("Thread running with ub: ", upperbound, "lb: ", lowerbound)
    for i in range(lowerbound, upperbound):
        for k in range(B.n):
            for j in range(A.n):
                C.matrix[i][k] += A.matrix[i][j] * B.matrix[j][k]
    #print("Tread finished")

def threaded(A, B, C):
    threads = []
    step = int(A.m / 8)

    for i in range(8):
        if i == 7:
            threads.append(multiprocessing.Process(target=matrixMult, args=(A, B, C,A.m, i*step)))
        threads.append(multiprocessing.Process(target=matrixMult, args=(A, B, C, ((i+1)*step), i*step)))
        threads[i].start()

    for i in range(8):
        threads[i].join()

def main():
    m = 540
    n = 540

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