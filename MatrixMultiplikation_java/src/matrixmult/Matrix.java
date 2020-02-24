package matrixmult;

import java.util.Random;

public class Matrix {
    private int[][] matrix;

    Matrix(int n, int m) throws Exception {
        if(n == 0 || m == 0) throw new Exception("n = 0 or m = 0 is not permitted");
        matrix = new int[n][m];
    }

    public void randomize() {
        Random generator = new Random();
        for (int r = 0; r < matrix.length; r++) {
            for (int c = 0; c < matrix[0].length; c++) {
                matrix[r][c] = generator.nextInt(100);
            }
        }
    }

    public void print() {
        for (int[] rows : matrix) {
            for (int c = 0; c < matrix[0].length; c++)
                System.out.print(rows[c] + " ");
            System.out.println();
        }
        System.out.println();
    }

    public int[][] getMatrix() {
        return matrix;
    }
}