#lang turnstile/quicklang

(provide Bool Int String ->
         (rename-out [typed-+     +]
                     [typed-app   #%app]
                     [typed-datum #%datum]))

(define-base-types Int String Bool)
(define-type-constructor -> #:arity > 0)

(define-typerule typed-datum
  [(_ . n:boolean) ≫
   -----
   [⊢ (#%datum . n) ⇒ Bool]]
  [(_ . n:integer) ≫
   -----
   [⊢ (#%datum . n) ⇒ Int]]
  [(_ . n:string) ≫
   -----
   [⊢ (#%datum . n) ⇒ String]])

(define-primop typed-+ + : (-> Int Int Int))

#;
(define-typerule (typed-λ ([x (~datum :) τin] ...) e) ≫
  [[x ≫ x- : τin] ... ⊢ e ≫ e- ⇒ τout]
  -----
  [⊢ (λ (x- ...) e-) ⇒ (-> τin ... τout)])

#;
(define-typerule typed-if
  [(_ (~literal if) e1 e2 e3) ⇐ τ ≫
   -----
   [⊢]]
  [(_ (~literal if) e1 e2 e3) ≫
   -----
   [⊢]])
  
(define-typerule typed-app
  [(_ f e ...) ⇐ τout ≫
   [⊢ e ≫ e- ⇒ τin] ...
   #:fail-unless (stx-length=? #'(τin ...) #'(e ...))
                 "args does not match arity"
   [⊢ f ≫ f- ⇐ (-> τin ... τout)]
   -----
   [⊢ (#%app f- e- ...)]]
  [(_ f e ...) ≫
   [⊢ f ≫ f- ⇒ (~-> τin ... τout)]
   #:fail-unless (stx-length=? #'(τin ...) #'(e ...))
                 "args does not match arity"
   [⊢ e ≫ e- ⇐ τin] ...
   -----
   [⊢ (#%app f- e- ...) ⇒ τout]])
