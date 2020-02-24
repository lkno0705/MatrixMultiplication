class MatrixThreadRunner(private val matrixA: Matrix, private val matrixB: Matrix, private val upperBound: Int, private val lowerBound: Int) : Runnable {
    override fun run() {
        try {
            val matrixC = Matrix(matrixA.matrix.size, matrixA.matrix[0].size)
            for (i in lowerBound until upperBound) {
                for (k in matrixB.matrix.indices) {
                    for (j in matrixA.matrix.indices)
                        matrixC.matrix[i][k] += matrixA.matrix[i][j] * matrixB.matrix[j][k]
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}