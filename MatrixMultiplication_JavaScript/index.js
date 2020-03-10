class Matrix {
    constructor(numRows, numCols, matrix) {
        this.n = numRows;
        this.m = numCols;
        this.matrix = matrix;
        if(matrix.length != numRows) {
            initMatrixZero(this);
        }
    }
}

function matrixMult({n, m, matrix: dest}, {n: bn, matrix: bmatrix}, {matrix: amatrix}, upper, lower) {
    for(let i = lower; i < upper; i++) {
        for(let j = 0; j < m; j++) {
            let sum = 0;
            for(let k = 0; k < bn; k++) {
                sum += amatrix[i][k] * bmatrix[k][j];
            }
            dest[i][j] = sum;
        }
    }
}

function initMatrixZero({n, m, matrix}) {
    for(let i = 0; i < n; i++) {
        let row = [];
        for(let j = 0; j < m; j++) {
            row.push(0);
        }
        matrix.push(row);
    }
}

function zeroMatrix({n, m, matrix}) {
    for(let i = 0; i < n; i++) {
        for(let j = 0; j < m; j++) {
            matrix[i][j] = 0;
        }
    }
}

function randomizeMatrix({n, m, matrix}) {
    for(let i = 0; i < n; i++) {
        for(let j = 0; j < m; j++) {
            matrix[i][j] = Math.random() * 100;
        }
    }
}

const {
  performance
} = require('perf_hooks');

let a = new Matrix(1440, 1440, []);
let b = new Matrix(1440, 1440, []);
let c = new Matrix(1440, 1440, []);

randomizeMatrix(a);
randomizeMatrix(b);

let t1 = performance.now();
matrixMult(c, b, a, 1440, 0);
let t2 = performance.now();
console.log("Time elapsed", (t2-t1) / 1000, "s");