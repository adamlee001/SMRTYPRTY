(require-extension sicp)
;; (require-extension numbers)

;; SICP Chapter 1, Section 1.2, Procedures and the Processes they
;; Generate

;; Exercise 1.9: Each of the following two procedures defines a method
;; for adding two positive integers in terms of the procedures inc,
;; which increments its argument by 1, and dec, which decrements its
;; argument by 1.

;; (define (+ a b)
;;   (if (= a 0)
;;       b
;;       (inc (+ (dec a) b))))

;; (define (+ a b)
;;   (if (= a 0)
;;       b
;;       (+ (dec a) (inc b))))

;; Using the substitution model, illustrate the process generated by
;; each procedure in evaluating (+ 4 5). Are these processes iterative
;; or recursive?

;; Answer for the first fn:

;; (+ 4 5)
;; (inc (+ 3 5))
;; (inc (inc (+ 2 5)))
;; (inc (inc (inc (+ 1 5))))
;; (inc (inc (inc (inc 5))))
;; (inc (inc (inc 6)))
;; (inc (inc 7))
;; (inc 8)
;; 9

;; Answer for the second fn:

;; (+ 4 5)
;; (+ 3 6)
;; (+ 2 7)
;; (+ 1 8)
;; (+ 0 9)
;; 9

;; The first process is recursive, the second is iterative.


;; Exercise 1.10: The following procedure computes a mathematical
;; function called Ackermann’s function.

(define (A m n)
  (cond ((= n 0) 0)
        ((= m 0) (* 2 n))
        ((= n 1) 2)
        (else (A (- m 1)
                 (A m (- n 1))))))

;; what are the values of the following expressions?

;; (A 1 10) => 1024
;; (A 2 4)  => 65536
;; (A 3 3)  => 65536

;; Consider the following procedures, where A is the procedure defined above:

(define (f n) (A 0 n))

;; (A 0 5)
;; (* 2 5)
;; 10

(define (g n) (A 1 n))

;; (A 1 5)
;; (A 0 (A 1 4))
;; (A 0 (A 0 (A 1 3)))
;; (A 0 (A 0 (A 0 (A 1 2))))
;; (A 0 (A 0 (A 0 (A 0 (A 1 1)))))
;; (A 0 (A 0 (A 0 (A 0 2))))
;; (A 0 (A 0 (A 0 4)))
;; (A 0 (A 0 8))
;; (A 0 16)
;; 32

(define (h n) (A 2 n))

;; (A 2 2)
;; (A 1 (A 2 1))
;; (A 1 2)
;; (A 0 (A 1 1))
;; (A 0 2)
;; 4

;; (A 2 4)
;; (A 1 (A 2 3))
;; (A 1 (A 1 (A 2 2)))
;; (A 1 (A 1 (A 1 (A 2 1))))
;; (A 1 (A 1 (A 1 2)))
;; (A 1 (A 1 (A 0 (A 1 1))))
;; (A 1 (A 1 (A 0 2)))
;; (A 1 (A 1 4))
;; (A 1 (A 0 (A 1 3)))
;; (A 1 (A 0 (A 0 (A 1 2))))
;; (A 1 (A 0 (A 0 (A 0 (A 1 1)))))
;; (A 1 (A 0 (A 0 (A 0 2))))
;; (A 1 (A 0 (A 0 4)))
;; (A 1 (A 0 8))
;; (A 1 16)
;; (A 0 (A 1 15))
;; (A 0 (A 0 (A 1 14)))
;; (A 0 (A 0 (A 0 (A 1 13))))
;; (A 0 (A 0 (A 0 (A 0 (A 1 12)))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 11))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 10)))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 9))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 8)))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 7))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 6)))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 5))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 4)))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 3))))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 2)))))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 1))))))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 2)))))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 4))))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 8)))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 16))))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 32)))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 64))))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 128)))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 256))))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 512)))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 1024))))))
;; (A 0 (A 0 (A 0 (A 0 (A 0 2048)))))
;; (A 0 (A 0 (A 0 (A 0 4096))))
;; (A 0 (A 0 (A 0 8192)))
;; (A 0 (A 0 16384))
;; (A 0 32768)
;; 65536

(define (k n) (* 5 n n))

;; Give concise mathematical definitions for the functions computed by
;; the procedures f, g, and h for positive integer values of nn. For
;; example, (k n) computes 5n^2

;; Answer:

;; (f n) computes 2n
;; (g n) computes 2^n

;; (h n) computes n^h(n-1)

;; Mind blown. I can't quite grasp it, and I also note that the
;; definition of this fn on wikipedia is slightly different, though
;; only in the base cases.

;; Kevin found a great discussion on Wolfram Alpha:
;;   http://mathworld.wolfram.com/AckermannFunction.html

;; Things I found useful to have around while working:

(define (range x)
  (define (iter x y)
    (if (= x 0)
        y
        (iter (- x 1) (cons x y))))
  (iter x '()))

(define (repeat x y)
  (define (iter x z)
    (if (= x 0)
        z
        (iter (- x 1) (cons y z))))
  (iter x '()))

(define (pow x y)
  (apply * (repeat y x)))

;; Tree Recursion - fibonacci

(define (fib-recursive n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib-recursive (- n 1))
                 (fib-recursive (- n 2))))))

;; Iterative version

(define (fib-iterative n)
  (fib-iter 1 0 n))

(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

;; Coin counting

(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0)
             (= kinds-of-coins 0))
         0)
        (else
         (+ (cc amount (- kinds-of-coins 1))
            (cc (- amount (first-denomination
                           kinds-of-coins))
                kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

;; From the book:

;; Count-change generates a tree-recursive process with redundancies
;; similar to those in our first implementation of fib. (It will take
;; quite a while for that 292 to be computed.) On the other hand, it
;; is not obvious how to design a better algorithm for computing the
;; result, and we leave this problem as a challenge.

;; LOL @ "take quite a while". Maybe in 1985.

;; Exercise 1.11

;; A function f is defined by the rule that f(n)=n if n<3 and
;; f(n)=f(n−1)+2f(n−2)+3f(n−3) if n≥3. Write a procedure that computes
;; f by means of a recursive process. Write a procedure that computes
;; f by means of an iterative process.

(define (f-recursive n)
  (if (< n 3)
      n
      (+ (f-recursive (- n 1))
         (* 2 (f-recursive (- n 2)))
         (* 3 (f-recursive (- n 3))))))

(define (f-iterative n)
  (define (iter c x y z)
    (if (= c n)
        x
        (iter (+ c 1) (+ x (* 2 y) (* 3 z)) x y)))
  (if (< n 3)
      n
      (iter 2 2 1 0)))

;; Exercise 1.12

;; The following pattern of numbers is called Pascal’s triangle.

;;          1
;;        1   1
;;      1   2   1
;;    1   3   3   1
;;  1   4   6   4   1
;;        . . .

;; The numbers at the edge of the triangle are all 1, and each number
;; inside the triangle is the sum of the two numbers above it.35 Write
;; a procedure that computes elements of Pascal’s triangle by means of
;; a recursive process.

(define (p1 r)
  (define (partition lst)
    (if (null? (cdr lst))
        '()
        (cons (cons (car lst)
                    (list (cadr lst)))
              (partition (cdr lst)))))
  (define (sum-pairs lst)
    (if (null? lst)
        '()
        (cons (apply + (car lst))
              (sum-pairs (cdr lst)))))
  (if (= r 1)
      '(1)
      (cons 1 (reverse (cons 1 (sum-pairs (partition (p1 (- r 1)))))))))

;; An earlier time through, I had come up with another solution for
;; this:

(define (p2 r)
  (define (len lst n)
    (if (null? lst)
        n
        (len (cdr lst) (inc n))))
  (define (p-row last-row this-row)
    (if (= (len last-row 0) 1)
        (reverse (cons 1 this-row))
        (p-row (cdr last-row)
               (cons (+ (car last-row)
                        (cadr last-row))
                     this-row))))
  (cond ((= r 1) '(1))
        ((= r 2) '(1 1))
        (else (p-row (p2 (- r 1)) '(1)))))

;; I was surprised to find just now that this version is *much*
;; slower. I'm interested to know why. Maybe something to talk about.

;; So, on reflection it seems that lists are not officially known at
;; this point. So really we want to be calculating an element based on
;; its position, and finding a way to do that recursively.

(define (p3 row col)
  (cond ((or (> col row) (< col 0) (< row 0)) 0)
        ((or (= row 1) (<= col 1) (= col row)) 1)
        (else (+ (p3 (dec row) col)
                 (p3 (dec row) (dec col))))))

;; Exercise 1.13: Prove that Fib(n) is the closest integer to φn/√5,
;; where φ=(1+√5)/2. Hint: Let ψ=(1-√5)/2. Use induction and the
;; definition of the Fibonacci numbers (see 1.2.2) to prove that
;; Fib(n)=(φn-ψn)/√5.

;; Deferring this...

;; Exercise 1.14: Draw the tree illustrating the process generated by
;; the count-change procedure of 1.2.2 in making change for 11 cents.
;; What are the orders of growth of the space and number of steps used
;; by this process as the amount to be changed increases?

;; Exercise 1.15: The sine of an angle (specified in radians) can be
;; computed by making use of the approximation sin(x) ≈ x if x is
;; sufficiently small, and the trigonometric identity
;;            sin(x) = 3*sin(x/3) − 4*sin^3(x/3)

;; to reduce the size of the argument of sin. (For purposes of this
;; exercise an angle is considered “sufficiently small” if its
;; magnitude is not greater than 0.1 radians.) These ideas are
;; incorporated in the following procedures:

(define (cube x)
  (* x x x))

(define (p x)
  (print "ping")
  (- (* 3 x)
     (* 4 (cube x))))

(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))

;; 1. How many times is the procedure p applied when (sine 12.15) is
;;    evaluated?

;; p is called 5 times

;; 2. What is the order of growth in space and number of steps (as a
;;    function of a) used by the process generated by the sine
;;    procedure when (sine a) is evaluated?

;; O(log n)

;; Exercise 1.16: Design a procedure that evolves an iterative
;; exponentiation process that uses successive squaring and uses a
;; logarithmic number of steps, as does fast-expt. (Hint: Using the
;; observation that (b^n/2)^2 = (b^2)^n/2, keep, along with the
;; exponent n and the base b, an additional state variable a, and
;; define the state transformation in such a way that the product ab^n
;; is unchanged from state to state. At the beginning of the process a
;; is taken to be 1, and the answer is given by the value of a at the
;; end of the process. In general, the technique of defining an
;; invariant quantity that remains unchanged from state to state is a
;; powerful way to think about the design of iterative algorithms.)

;; this is the recursive but O(log n) version from the book:

;; (fast-expt 2 5)
;; (* 2 (fast-expt 2 4))
;; (* 2 (square (fast-expt 2 2)))
;; (* 2 (square (square (fast-expt 2 1))))
;; (* 2 (square (square (* 2 (fast-expt 2 0)))))
;; (* 2 (square (square (* 2 1))))
;; (* 2 (square (square 2)))
;; (* 2 (square 4))
;; (* 2 16)
;; 32

(define (fast-expt b n)
  (cond ((= n 0)
         1)
        ((even? n)
         (square (fast-expt b (/ n 2))))
        (else
         (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))

;; Here's my attempt:

;; b      2    4   16  256  256
;; n      8    4    2    1    0
;; b^n  256  256  256  256    1
;; a      1    1    1    1  256
;; ab^n 256  256  256  256    1

;; b      2    2    4   16   16
;; n      5    4    2    1    0
;; b^n   32   16   16   16    1
;; a      1    2    2    2   32
;; ab^n  32  256   64   32    1

(define (fast-expt-iterative b n)
  (define (expt-iter b n a)
    (print "a=" a " b=" b " n=" n " ab^n=" (* a (pow b n)))
    (cond ((= n 0)
           a)
          ((even? n)
           (expt-iter (square b) (/ n 2) a))
          (else
           (expt-iter b (- n 1) (* a b)))))
  (expt-iter b n 1))

;; Exercise 1.17: The exponentiation algorithms in this section are
;; based on performing exponentiation by means of repeated
;; multiplication. In a similar way, one can perform integer
;; multiplication by means of repeated addition. The following
;; multiplication procedure (in which it is assumed that our language
;; can only add, not multiply) is analogous to the expt procedure:

(define (mult a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

;; This algorithm takes a number of steps that is linear in b. Now
;; suppose we include, together with addition, operations double,
;; which doubles an integer, and halve, which divides an (even)
;; integer by 2. Using these, design a multiplication procedure
;; analogous to fast-expt that uses a logarithmic number of steps.

(define (double x)
  (+ x x))

(define (halve x)
  (/ x 2))

(define (mult2 x y)
  (define (iter x y a)
    (print "x=" x " y=" y " a=" a)
    (cond ((= x 0)
           a)
          ((even? x)
           (iter (halve x) (double y) a))
          (else
           (iter (- x 1) y (+ a y)))))
  (iter x y 0))

;; The actual solution

(define (mult3 x y)
  (cond ((= x 1)
         y)
        ((even? x)
         (double (mult3 (halve x) y)))
        (else
         (+ y (mult3 (- x 1) y)))))

;; Exercise 1.18: Using the results of Exercise 1.16 and Exercise
;; 1.17, devise a procedure that generates an iterative process for
;; multiplying two integers in terms of adding, doubling, and halving
;; and uses a logarithmic number of steps.

(define (russian-mult x y)
  (define (russian-halve x)
    (/ (- x (modulo x 2)) 2))
  (define (iter x y a)
    (cond ((= y 1)
           (+ a x))
          ((even? y)
           (iter (double x) (russian-halve y) a))
          (else
           (iter (double x) (russian-halve y) (+ a x)))))
  (iter x y 0))

;; For fun

(define (russian-mult-recursive x y)
  (define (russian-halve x)
    (/ (- x (modulo x 2)) 2))
  (cond ((= y 1)
         x)
        ((even? y)
         (russian-mult-recursive (double x) (russian-halve y)))
        (else
         (+ x (russian-mult-recursive (double x) (russian-halve y))))))

;; Exercise 1.19: There is a clever algorithm for computing the
;; Fibonacci numbers in a logarithmic number of steps. Recall the
;; transformation of the state variables aa and bb in the fib-iter
;; process of 1.2.2: a ← a+b and b ← a. Call this transformation T,
;; and observe that applying T over and over again n times, starting
;; with 1 and 0, produces the pair Fib(n+1) and Fib(n). In other
;; words, the Fibonacci numbers are produced by applying T^n, the nth
;; power of the transformation T, starting with the pair (1, 0). Now
;; consider T to be the special case of p=0 and q=1 in a family of
;; transformations Tpq, where Tpq transforms the pair (a,b) according
;; to a ← bq+aq+ap and b ← bp+aq. Show that if we apply such a
;; transformation Tpq twice, the effect is the same as using a single
;; transformation Tp′q′ of the same form, and compute p′ and q′ in
;; terms of p and q. This gives us an explicit way to square these
;; transformations, and thus we can compute Tn using successive
;; squaring, as in the fast-expt procedure. Put this all together to
;; complete the following procedure, which runs in a logarithmic
;; number of steps:

(define (fib-clever n)
  (fib-clever-iter 1 0 0 1 n))

(define (fib-clever-iter a b p q count)
  (cond ((= count 0)
         b)
        ((even? count)
         (fib-clever-iter a
                          b
                          (+ (square p) (square q))       ;;compute p'
                          (+ (square q) (double (* p q))) ;;compute q'
                          (/ count 2)))
        (else
         (fib-clever-iter (+ (* b q)
                             (* a q)
                             (* a p))
                          (+ (* b p)
                             (* a q))
                          p
                          q
                          (- count 1)))))

;; Exercise 1.20: The process that a procedure generates is of course
;; dependent on the rules used by the interpreter. As an example,
;; consider the iterative gcd procedure given above. Suppose we were
;; to interpret this procedure using normal-order evaluation, as
;; discussed in 1.1.5. (The normal-order-evaluation rule for if is
;; described in Exercise 1.5.) Using the substitution method (for
;; normal order), illustrate the process generated in evaluating (gcd
;; 206 40) and indicate the remainder operations that are actually
;; performed. How many remainder operations are actually performed in
;; the normal-order evaluation of (gcd 206 40)? In the
;; applicative-order evaluation?

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; Normal order:

;; (gcd 206
;;      40)

;; (gcd 40
;;      (remainder 206 40))

;; (gcd (remainder 206 40)
;;      (remainder 40 (remainder 206 40)))

;; (gcd (remainder 40 (remainder 206 40))
;;      (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))

;; (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
;;      (remainder (remainder 40 (remainder 206 40))
;;                 (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

;; so 14 evaluations of `remainder` in the conditional and 4
;; evaluations for returning a, which is value 2. 18 in total.

;; Applicative order:

;; (gcd 206 40)
;; (gcd 40 (remainder 206 40))
;; (gcd 40 6)
;; (gcd 6 (remainder 40 6))
;; (gcd 6 4)
;; (gcd 4 (remainder 6 4))
;; (gcd 4 2)
;; (gcd 2 (remainder 4 2))
;; (gcd 2 0)
;; 2

;; 4 evaluations over all
