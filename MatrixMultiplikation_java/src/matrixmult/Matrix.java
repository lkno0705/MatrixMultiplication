package matrixmult;

import java.util.Random;

public class Matrix{
        int[][] matrix;
        int n;
        int m;

        public void createRandomMatrix(int m, int n){
                Random generator = new Random();
                createEmptyMatrix(m, n);
                for (int r = 0; r < m; r++){
                        for (int c = 0; c < n; c++){
                                this.matrix[r][c] = generator.nextInt(100);
                        }
                }
                return;
        }

        public void print(){
                for (int i = 0; i < this.m; i++){
                        for (int j = 0; j < this.n; j++)
                                System.out.print(this.matrix[i][j] + " ");
                        System.out.println();
                }
                System.out.println();
                return;
        }

        public void createEmptyMatrix(int m, int n){
                this.n = n;
                this.m = m;
                this.matrix = new int[m][n];
                return;
        }

}
