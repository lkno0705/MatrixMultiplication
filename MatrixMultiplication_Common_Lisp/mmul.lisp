; # Run
; sbcl --load mmul.lisp

(defmacro mref (matrix row col)
    `(aref (cadr ,matrix) (+ ,col (* ,row (cdar ,matrix)))))

(defun make-matrix (rows cols &optional &key (initial-element 0.0))
    `((,rows . ,cols)
      ,(make-array (* cols rows) :initial-element initial-element :element-type 'float)))

(defun randomize-matrix (m)
    `(,(car m)
      ,(map 'vector (lambda (x) (random 100.0)) (cadr m))))

(defun mmul (a b)
    (let* ((rows (caar a))
           (cols (cdar b))
           (b-rows (caar b))
           (result (make-matrix rows cols))
           (temp-sum 0.0))
        (dotimes (row rows)
            (dotimes (col cols)
                (setq temp-sum 0.0)
                (dotimes (i b-rows)
                    (setq temp-sum (+ temp-sum (* (mref a row i) (mref b i col))))
                (setf (mref result row col) temp-sum))))
        result))

(defvar *a* (randomize-matrix (make-matrix 1440 1440)))
(defvar *b* (randomize-matrix (make-matrix 1440 1440)))

(time (mmul *a* *b*))