<?php
    $num_threads = 24;
    $rows = 1440;
    $cols = 1440;

    // Initialize objects
    echo("Initializing ...");
    $matrixA = new Matrix();
    $matrixB = new Matrix();
    $result = new Matrix();

    $matrixA->randomize();
    $matrixB->randomize();
    $result->initialize();

    echo("Starting benchmark ...");
    $start_time = microtime(true);
    $result = multiply($matrixA, $matrixB, $result, false);
    $end_time = microtime(true);
    $duration = round(($end_time - $start_time) / 1000000, 2);
    echo("Without Threading: $duration");

    // TODO: Add threaded version here

    exit;

    // --------------------- Functions -------------------------

    function multiply($a, $b, $c, $threaded) {
        global $rows, $cols, $num_threads;

        if($threaded) {
            // TODO: Add threaded version here
        } else {
            for($i = 0; $i < $rows; $i++) {
                for($k = 0; $k < $cols; $k++) {
                    for($j = 0; $j < $cols; $j++) {
                        $c->getMatrix()[$i][$k] += $a->getMatrix()[$i][$j] * $b->getMatrix()[$j][$k];
                    }
                }
                echo($i);
            }
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
?>