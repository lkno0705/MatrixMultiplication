<?php
    $num_threads = 24;
    $rows = 240;
    $cols = 240;

    // Initialize objects
    echo("Initializing ...");
    $matrixA = new Matrix();
    $matrixB = new Matrix();
    $result_single = new Matrix();
    $result_multi = new Matrix();

    $matrixA->randomize();
    $matrixB->randomize();
    // $result_single->initialize();
    // $result_multi->initialize(); // not needed anymore because of new summation

    // Single thread
    echo("Starting benchmark ...");
    $start_time = microtime(true);
    $result_single = multiply($matrixA, $matrixB, $result_single, false);
    $end_time = microtime(true);
    $duration = round(($end_time - $start_time), 2);
    echo("Without Threading: $duration");

    // Multiple threads
    $start_time = microtime(true);
    $result_multi = multiply($matrixA, $matrixB, $result_multi, false);
    $end_time = microtime(true);
    $duration = round(($end_time - $start_time), 2);
    echo("With Threading: $duration");
    exit;

    // --------------------- Functions -------------------------

    function multiply($a, $b, $c, $threaded) {
        global $rows, $cols, $num_threads;

        if($threaded) {
            $threads = array();
            $step = $rows / $num_threads;
            for($i = 0; $i < $num_threads; $i++) {
                if($i == 23)
                    $threads[] = new MatrixThread($a, $b, $c, $rows, $i * $step);
                else
                    $threads[] = new MatrixThread($a, $b, $c, ($i + 1) * $step, $i * $step);
                end($threads)->start();
            }
            for($i = 0; $i < $num_threads; $i++) {
                $threads[$i]->join();
            }
        } else {
            $b_matrix = $b->getMatrix();
            for($i = 0; $i < $rows; $i++) {
                $a_row = $a->getMatrix()[$i];
                $c_row = $c->getMatrix()[$i];
                for($k = 0; $k < $cols; $k++) {
                    $sum = 0;
                    for($j = 0; $j < $cols; $j++) {
                        $sum += $a_row[$j] * $b_matrix[$j][$k];
                    }
                    $c_row[$k] = $sum;
                }
            }
            /*for($i = 0; $i < $rows; $i++) {
                for($k = 0; $k < $cols; $k++) {
                    for($j = 0; $j < $cols; $j++) {
                        $c->getMatrix()[$i][$k] += $a->getMatrix()[$i][$j] * $b->getMatrix()[$j][$k];
                    }
                }
            }*/
            return $c;
        }
    }

    // ---------------------- Classes --------------------------

    class Matrix {
        var $matrix = array();

        function initialize() {
            global $rows, $cols;

            for($y = 0; $y < $rows; $y++) {
                $current_row = array();
                for($x = 0; $x < $cols; $x++) $current_row[] = 0;
                $this->matrix[] = $current_row;
            }
        }

        function randomize() {
            global $rows, $cols;

            for($y = 0; $y < $rows; $y++) {
                $current_row = array();
                for($x = 0; $x < $cols; $x++) {
                    $current_row[] = random_int(0, 99);
                }
                $this->matrix[] = $current_row;
            }
        }

        function getMatrix() {
            return $this->matrix;
        }
    }

    class MatrixThread extends Thread {
        var $matrixA;
        var $matrixB;
        var $matrixC;
        var $upperBound;
        var $lowerBound;

        public function __construct($matrixA, $matrixB, $matrixC, $upperBound, $lowerBound) {
            $this->matrixA = $matrixA;
            $this->matrixB = $matrixB;
            $this->matrixC = $matrixC;
            $this->upperBound = $upperBound;
            $this->lowerBound = $lowerBound;
        }

        public function run() {
            global $rows, $cols;

            for($i = $lowerBound; $i < $upperBound; $i++) {
                for($k = 0; $k < count($matrixB->getMatrix()); $k++) {
                    for($j = 0; $j < count($matrixA->getMatrix()); $j++) {
                        $c->getMatrix()[$i][$k] += $a->getMatrix()[$i][$j] * $b->getMatrix()[$j][$k];
                    }
                }
            }
        }
    }
?>