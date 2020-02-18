package matrixmult;

public class MatrixThreadrunner implements Runnable {
    private Matrix matrixC;
    private Matrix matrixA;
    private Matrix matrixB;
    private int upperBound;
    private int lowerBound;

    MatrixThreadrunner(Matrix matrixA, Matrix matrixB, Matrix matrixC, int upperBound, int lowerBound) {
        this.matrixA = matrixA;
        this.matrixB = matrixB;
        this.matrixC = matrixC;
        this.upperBound = upperBound;
        this.lowerBound = lowerBound;
    }

    public void run() {
        for (int i = this.lowerBound; i < this.upperBound; i++) {
            for (int k = 0; k < this.matrixB.n; k++) {
                for (int j = 0; j < this.matrixA.n; j++) {
                    this.matrixC.matrix[i][k] += this.matrixA.matrix[i][j] * this.matrixB.matrix[j][k];
                }
            }
        }
    }
}
