package matrixmult;

public class MatrixThreadRunner implements Runnable {
    private Matrix matrixA;
    private Matrix matrixB;
    private Matrix matrixC;
    private int upperBound;
    private int lowerBound;

    MatrixThreadRunner(Matrix matrixA, Matrix matrixB, Matrix matrixC, int upperBound, int lowerBound) {
        this.matrixA = matrixA;
        this.matrixB = matrixB;
        this.upperBound = upperBound;
        this.lowerBound = lowerBound;
        this.matrixC = matrixC;
    }

    public void run() {
        try {
            for (int i = lowerBound; i < upperBound; i++) {
                for (int k = 0; k < matrixB.getMatrix().length; k++) {
                    for (int j = 0; j < matrixA.getMatrix().length; j++) {
                        matrixC.getMatrix()[i][k] += matrixA.getMatrix()[i][j] * matrixB.getMatrix()[j][k];
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}