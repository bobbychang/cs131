#lang racket

(define match-junk
  (lambda (k frag backtrack)
    (or 
     ; Match nothing first
     (call/cc (lambda (cc)
		(cons frag (lambda () (cc #f)))))
     ; Match 1, then call recursively
     (and (or (< 0 k) (backtrack))
	  (or (pair? frag) (backtrack))
	  (match-junk (- k 1) (cdr frag) backtrack)))))

(define match-*
  (lambda (matcher frag backtrack)
    (or
     ; Match nothing first
     (call/cc (lambda (cc)
		(cons frag (lambda () (cc #f)))))
     ; Use the matcher to find a single instance of the pattern
     (let ((ret (matcher frag backtrack)))
       ; Call recursively on the new fragment and the matcher's backtrack
       (match-* matcher (car ret) (cdr ret))))))

(define make-matcher-cc
  (lambda (pat)
    (cond
     
     ((symbol? pat)
      (lambda (frag backtrack)
	(and (or (pair? frag) (backtrack))
	     (or (eq? pat (car frag)) (backtrack))
	     (cons (cdr frag) backtrack))))

     ((eq? 'or (car pat))
      (let make-or-matcher ((pats (cdr pat)))
	(if (null? pats)
	    (lambda (frag backtrack) (backtrack))
	    (let ((head-matcher (make-matcher-cc (car pats)))
		  (tail-matcher (make-or-matcher (cdr pats))))
	      (lambda (frag backtrack)
		(or 
		 (call/cc (lambda (cc)
			    (head-matcher frag (lambda () (cc #f)))))
		 (tail-matcher frag backtrack)))))))
     
     ((eq? 'list (car pat))
      (let make-list-matcher ((pats (cdr pat)))
	(if (null? pats)
	    (lambda (frag backtrack) (cons frag backtrack))
	    (let ((head-matcher (make-matcher-cc (car pats)))
		  (tail-matcher (make-list-matcher (cdr pats))))
	      (lambda (frag backtrack)
		(let ((ret (head-matcher frag backtrack)))
		  (tail-matcher (car ret) (cdr ret))))))))
     
     ((eq? 'junk (car pat))
      (let ((k (cadr pat)))
	(lambda (frag backtrack)
	  (match-junk k frag backtrack))))
     
     ((eq? '* (car pat))
      (let ((matcher (make-matcher-cc (cadr pat))))
	(lambda (frag backtrack)
	  (match-* matcher frag backtrack)))))))

(define make-matcher
  (lambda (pat)
    (let ((matcher (make-matcher-cc pat)))
      (lambda (frag)
	 ; needs to have a backtrack point here for the final backtrack
	 (call/cc (lambda (cc)
		    (matcher frag (lambda () (cc #f)))))))))
