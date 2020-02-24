const val NUM_THREADS = 24
const val nA = 1440
const val mA = 1440
const val nB = nA
const val mB = mA

fun main() {
    val matrixA = Matrix(nA, mA)
    val matrixB = Matrix(nB, mB)

    matrixA.randomize()
    matrixB.randomize()

    val startTimeWOT = System.currentTimeMillis()
    multMatrix(matrixA, matrixB, false)
    println("Without Threading: ${(System.currentTimeMillis() - startTimeWOT) / 1000.0} s")

    val startTimeWT = System.currentTimeMillis()
    multMatrix(matrixA, matrixB, true)
    println("With Threading: ${(System.currentTimeMillis() - startTimeWT) / 1000.0} s")
}

private fun multMatrix(a: Matrix, b: Matrix, threading: Boolean): Matrix {
    val c = Matrix(nA, nB)
    if (threading) {
        val threads = arrayOfNulls<Thread>(NUM_THREADS)
        val step = mA / NUM_THREADS
        for (i in 0 until NUM_THREADS) {
            if (i == 23)
                threads[i] = Thread(MatrixThreadRunner(a, b, mA, i * step))
            else threads[i] =
                Thread(MatrixThreadRunner(a, b, (i + 1) * step, i * step))
            threads[i]?.start()
        }
        for (i in 0 until NUM_THREADS) {
            try {
                threads[i]?.join()
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }
    } else {
        for (i in 0 until mA) {
            for (k in 0 until nB) {
                for (j in 0 until nA) {
                    c.matrix[i][k] = a.matrix[i][j] * b.matrix[j][k]
                }
            }
        }
    }
    return c
}