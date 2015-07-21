(in-package :nes-unit-testing)

(defun filter-quadrant-region-to-direction (line)
  (string= line "quadrant_region_to_direction:"))

(defvar *quadrant-region-to-direction* #( 9  3 15 21
                                         10  2 14 22
                                         11  1 13 23
                                         12  0 12  0
                                          9  3 15 21
                                          8  4 16 20
                                          7  5 17 19
                                          6  6 18 18))
(defvar *quadrant-region-to-direction-address* #x6000)

(defun run-test-arctan (&key y x expect)
  (let ((quadrant 3))
    (when (< x 0)
      (setf quadrant (- quadrant 1) x (- x)))
    (when (< y 0)
      (setf quadrant (- quadrant 2) y (- y)))
    (run-test-case :a quadrant :y y :x x)
    (expect-result :y expect)))

(deftest arctan-test
  (initialize-test-case :env `((quadrant :byte)
                               (x-delta :byte)
                               (y-delta :byte)
                               (half-value :byte)
                               (region-number :byte)
                               (small :byte)
                               (large :byte)
                               (quadrant-region-to-direction
                                ,*quadrant-region-to-direction-address*))
                        :filter-source #'filter-quadrant-region-to-direction)
  ; Fill the table in ram.
  (setf (cl-6502::get-range *quadrant-region-to-direction-address*)
        *quadrant-region-to-direction*)
  ; Test first quadrant (upper-right, quadrant=1).
  (run-test-arctan :y   -3 :x 30 :expect 0) ; * 7.5
  (run-test-arctan :y   -4 :x 30 :expect 1)
  (run-test-arctan :y  -11 :x 30 :expect 1) ; * 2.5
  (run-test-arctan :y  -12 :x 30 :expect 2)
  (run-test-arctan :y  -23 :x 30 :expect 2) ; * 1.25
  (run-test-arctan :y  -24 :x 30 :expect 3)
  (run-test-arctan :y  -29 :x 30 :expect 3) ; * 1
  (run-test-arctan :y  -31 :x 30 :expect 3)
  (run-test-arctan :y  -37 :x 30 :expect 3) ; / 1.25
  (run-test-arctan :y  -38 :x 30 :expect 4)
  (run-test-arctan :y  -75 :x 30 :expect 4) ; / 2.5
  (run-test-arctan :y  -76 :x 30 :expect 5)
  (run-test-arctan :y -225 :x 30 :expect 5) ; / 7.5
  (run-test-arctan :y -226 :x 30 :expect 6)

  ; Test second quadrant (upper-left, quadrant=0).
  (run-test-arctan :y -226 :x -30 :expect 6) ; / 7.5
  (run-test-arctan :y -225 :x -30 :expect 7)
  (run-test-arctan :y  -76 :x -30 :expect 7) ; / 2.5
  (run-test-arctan :y  -75 :x -30 :expect 8)
  (run-test-arctan :y  -38 :x -30 :expect 8) ; / 1.25
  (run-test-arctan :y  -37 :x -30 :expect 9)
  (run-test-arctan :y  -31 :x -30 :expect 9) ; * 1
  (run-test-arctan :y  -29 :x -30 :expect 9)
  (run-test-arctan :y  -24 :x -30 :expect 9) ; * 1.25
  (run-test-arctan :y  -23 :x -30 :expect 10)
  (run-test-arctan :y  -12 :x -30 :expect 10) ; * 2.5
  (run-test-arctan :y  -11 :x -30 :expect 11)
  (run-test-arctan :y   -4 :x -30 :expect 11) ; * 7.5
  (run-test-arctan :y   -3 :x -30 :expect 12)

  ; Test third quadrant (lower-left, quadrant=2).
  (run-test-arctan :y   3 :x -30 :expect 12) ; * 7.5
  (run-test-arctan :y   4 :x -30 :expect 13)
  (run-test-arctan :y  11 :x -30 :expect 13) ; * 2.5
  (run-test-arctan :y  12 :x -30 :expect 14)
  (run-test-arctan :y  23 :x -30 :expect 14) ; * 1.25
  (run-test-arctan :y  24 :x -30 :expect 15)
  (run-test-arctan :y  29 :x -30 :expect 15) ; * 1
  (run-test-arctan :y  31 :x -30 :expect 15)
  (run-test-arctan :y  37 :x -30 :expect 15) ; / 1.25
  (run-test-arctan :y  38 :x -30 :expect 16)
  (run-test-arctan :y  75 :x -30 :expect 16) ; / 2.5
  (run-test-arctan :y  76 :x -30 :expect 17)
  (run-test-arctan :y 225 :x -30 :expect 17) ; / 7.5
  (run-test-arctan :y 226 :x -30 :expect 18)

  ; Test fourth quadrant (lower-right, quadrant=3).
  (run-test-arctan :y 226 :x 30 :expect 18) ; / 7.5
  (run-test-arctan :y 225 :x 30 :expect 19)
  (run-test-arctan :y  76 :x 30 :expect 19) ; / 2.5
  (run-test-arctan :y  75 :x 30 :expect 20)
  (run-test-arctan :y  38 :x 30 :expect 20) ; / 1.25
  (run-test-arctan :y  37 :x 30 :expect 21)
  (run-test-arctan :y  31 :x 30 :expect 21) ; * 1
  (run-test-arctan :y  29 :x 30 :expect 21)
  (run-test-arctan :y  24 :x 30 :expect 21) ; * 1.25
  (run-test-arctan :y  23 :x 30 :expect 22)
  (run-test-arctan :y  12 :x 30 :expect 22) ; * 2.5
  (run-test-arctan :y  11 :x 30 :expect 23)
  (run-test-arctan :y   4 :x 30 :expect 23) ; * 7.5
  (run-test-arctan :y   3 :x 30 :expect  0)

  ; Test edge cases. Overflow when * 7.5.
  (run-test-arctan :y  49 :x 40 :expect 21)
  (run-test-arctan :y  51 :x 40 :expect 20)
  (run-test-arctan :y  99 :x 40 :expect 20)
  (run-test-arctan :y 101 :x 40 :expect 19)

  ; Test edge cases. Overflow when * 2.5.
  (run-test-arctan :y 150 :x 130 :expect 21)
  (run-test-arctan :y 120 :x 105 :expect 21))
