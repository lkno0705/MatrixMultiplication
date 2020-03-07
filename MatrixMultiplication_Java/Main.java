package matrixmult;

public class Main {

    // Initialization parameters
    private static final int NUM_THREADS = 24;
    private static final int nA = 1440;
    private static final int mA = 1440;
    private static final int nB = nA;
    private static final int mB = mA;

    public static void main(String[] args) {
        try {
            Matrix matrixA = new Matrix(nA, mA);
            Matrix matrixB = new Matrix(nB, mB);
            Matrix matrixCWT = new Matrix(mA, nB);
            Matrix matrixCWOT = new Matrix(mA, nB);

            matrixA.randomize();
            matrixB.randomize();

            long startTimeWOT = System.currentTimeMillis();
            matrixCWOT = multMatrix(matrixA, matrixB, matrixCWOT, false);
            System.out.println("Without Threading: " + ((System.currentTimeMillis() - startTimeWOT) / 1000.0) + " s");

            long startTimeWT = System.currentTimeMillis();
            matrixCWT = multMatrix(matrixA, matrixB, matrixCWT, true);
            System.out.println("With Threading: " + ((System.currentTimeMillis() - startTimeWT) / 1000.0) + " s");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static Matrix multMatrix(Matrix a, Matrix b, Matrix c, boolean threading) throws Exception {
        if (threading) {
            Thread[] threads = new Thread[NUM_THREADS];
            int step = mA / NUM_THREADS;
            for (int i = 0; i < NUM_THREADS; i++) {
                if (i == 23)
                    threads[i] = new Thread(new MatrixThreadRunner(a, b, c, mA, i * step));
                else
                    threads[i] = new Thread(new MatrixThreadRunner(a, b, c, (i + 1) * step, i * step));
                threads[i].start();
            }
            for (int i = 0; i < NUM_THREADS; i++) {
                try {
                    threads[i].join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        } else {
            for (int i = 0; i < mA; i++) {
                for (int k = 0; k < nB; k++) {
                    for (int j = 0; j < nA; j++) {
                        c.getMatrix()[i][k] += a.getMatrix()[i][j] * b.getMatrix()[j][k];
                    }
                }
            }
        }
        return c;
    }
}