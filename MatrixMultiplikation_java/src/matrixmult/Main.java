package matrixmult;


public class Main {

    public static void main(String[] args) {
        int mA = 1440;
        int nA = 1440;
        int mB = nA;
        int nB = 1440;

        Matrix matrixA = new Matrix();
        Matrix matrixB = new Matrix();
        Matrix matrixC = new Matrix();

        matrixA.createRandomMatrix(mA, nA);
        matrixB.createRandomMatrix(mB, nB);

        long startTimeWOT = System.currentTimeMillis();
        matrixC = matrixmult(matrixA, matrixB, matrixC, false);
        System.out.println("Ohne Threading: " + (double) ((System.currentTimeMillis() - startTimeWOT) / 1000.0) + " s");

        long startTimeWT = System.currentTimeMillis();
        matrixC = matrixmult(matrixA, matrixB, matrixC, true);
        System.out.println("Mit Threading: " + ((System.currentTimeMillis() - startTimeWT) / 1000.0) + " s");
    }

    private static Matrix matrixmult(Matrix A, Matrix B, Matrix C, Boolean threading) {
        C.createEmptyMatrix(A.m, B.n);
        if (threading) {
            Thread[] threads = new Thread[24];
            int step = A.m / 24;
            for (int i = 0; i < 24; i++) {
                if (i == 23) threads[i] = new Thread(new MatrixThreadrunner(A, B, C, (A.m), (i * step)));
                else threads[i] = new Thread(new MatrixThreadrunner(A, B, C, ((i + 1) * step), (i * step)));
                threads[i].start();
            }
            for (int i = 0; i < 24; i++) {
                try {
                    threads[i].join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            return C;
        } else {
            for (int i = 0; i < A.m; i++) {
                for (int k = 0; k < B.n; k++) {
                    for (int j = 0; j < A.n; j++) {
                        C.matrix[i][k] += A.matrix[i][j] * B.matrix[j][k];
                    }
                }
            }
            return C;
        }
    }
}

