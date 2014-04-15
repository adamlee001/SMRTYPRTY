#lang planet neil/sicp

(define (remove v ls)
  (cond ((null? ls) '())
        ((equal? v (car ls)) (remove v (cdr ls)))
        (else (cons (car ls) (remove v (cdr ls))))))

(define apply-in-underlying-scheme apply)

;; -------------------------------------------------------
;; The Metacircular Evaluator, p.364
;; -------------------------------------------------------

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((unbind? exp) (eval-unbind exp env))
        ((if? exp) (eval-if exp env))
        ((and? exp) (eval (and->if exp) env))
        ((or? exp) (eval (or->if exp) env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((let? exp) (eval (let->combination exp) env))
        ((let*? exp) (eval (let*->nested-lets exp) env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply1 (eval (operator exp) env)
                 (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

; If we call it 'apply', Racket overrides standard 'apply',
; so 'apply-in-underlying-scheme' wouldn't work.
(define (apply1 procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           arguments
           (procedure-environment procedure))))
        (else
         (error "Unknown procedure type -- APPLY" procedure))))

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)

;; Exercise 4.1, p.368
;; Operands evaluation order

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      ; Swap 'first' and 'rest' to make evaluation left-to-right
      (let* ((rest (list-of-values (rest-operands exps) env))
             (first (eval (first-operand exps) env)))
        (cons first rest))))

;(list-of-values (list 1 2 3) nil)

;; -------------------------------------------------------
;; Representing Expressions, p.368
;; -------------------------------------------------------

(define (tagged-list? exp tag)
  (and (pair? exp) (eq? (car exp) tag)))

(define (self-evaluating? exp)
  (or (number? exp) (string? exp)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp) (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF" clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

;; Exercise 4.4, p.374

(define (and? exp) (tagged-list? exp 'and))
(define (and->if exp) (expand-and-operands (operands exp)))

(define (expand-and-operands ops)
  (if (no-operands? ops)
      'true
      (make-if (first-operand ops)
               (expand-and-operands (rest-operands ops))
               'false)))

(define (or? exp) (tagged-list? exp 'or))
(define (or->if exp) (expand-or-operands (operands exp)))

(define (expand-or-operands ops)
  (if (no-operands? ops)
      'false
      (make-if (first-operand ops)
               'true
               (expand-or-operands (rest-operands ops)))))

;; Exercise 4.6, p.375

(define (let? exp) (tagged-list? exp 'let))
(define (let-vars exp) (map car (cadr exp)))
(define (let-vals exp) (map cadr (cadr exp)))
(define (let-body exp) (cddr exp))

(define (let->combination exp)
  (cons (make-lambda (let-vars exp) (let-body exp))
        (let-vals exp)))

;; Exercise 4.7, p.375

(define (let*? exp) (tagged-list? exp 'let*))

(define (let*->nested-lets exp)
  (let ((let-bindings (cadr exp))
        (let-body (caddr exp)))
    (define (expand-let-bindings bindings)
      (if (null? bindings)
          let-body
          (list 'let
                (list (car bindings))
                (expand-let-bindings (cdr bindings)))))
    (expand-let-bindings let-bindings)))

;> (let* ((x 3) (y (+ x 2)) (z (+ x y 5))) (* x z))

;; -------------------------------------------------------
;; Evaluator Data Structures, p.376
;; -------------------------------------------------------

(define (false? x) (eq? x false))
(define (true? x) (not (false? x)))

;(apply-primitive-procedure proc args)
;(primitive-procedure? proc)

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

;; Exercise 4.11, p.380

(define (make-frame variables values)
  (cons 'frame (map cons variables values)))

(define (frame-bindings frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-cdr! frame (cons (cons var val)
                        (frame-bindings frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

;; Exercise 4.12, p.380

(define ((set-val! val) var) (set-cdr! var val))

(define (do-in-frame var frame then-proc else-proc)
  (let ((binding (assoc var (frame-bindings frame))))
    (if binding
        (then-proc binding)
        (else-proc binding))))

(define (env-loop var env action)
  (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env))
            (try-next-frame
             (lambda (_)
               (env-loop var (enclosing-environment env) action))))
        (do-in-frame var frame action try-next-frame))))

(define (lookup-variable-value var env)
  (env-loop var env cdr))

(define (set-variable-value! var val env)
  (env-loop var env (set-val! val)))

(define (define-variable! var val env)
  (let* ((frame (first-frame env))
         (bind (lambda (_)
                 (add-binding-to-frame! var val frame))))
  (do-in-frame var frame (set-val! val) bind)))

;; Exercise 4.13, p.380

(define (unbind? exp) (tagged-list? exp 'forget))
(define (unbind-var exp) (cadr exp))

(define (eval-unbind exp env)
  (unbind-variable! (unbind-var exp) env)
  'ok)

(define (unbind-variable! var env)
  (let* ((frame (first-frame env))
         (unbind
          (lambda (binding)
            (set-cdr! frame (remove binding (frame-bindings frame))))))
    (do-in-frame var frame unbind identity)))

;; -------------------------------------------------------
;; Running Evaluator, p.381
;; -------------------------------------------------------

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '+ +)
        (list '* *)))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define the-global-environment (setup-environment))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let* ((input (read))
         (output (eval input the-global-environment)))
    (announce-output output-prompt)
    (user-print output))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;; -------------------------------------------------------
;; Exercises
;; -------------------------------------------------------

;; Exercise 4.2.b, p.374

;(define (application? exp) (tagged-list? exp 'call))
;(define (operator exp) (cadr exp))
;(define (operands exp) (cddr exp))

(driver-loop)
