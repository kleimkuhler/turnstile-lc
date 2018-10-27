#lang s-exp "turnstile-lc.rkt"

(require turnstile/rackunit-typechecking)

; datums
(check-type 0 : Int)
(check-type #t : Bool)
(check-type "foo" : String)

; +
(check-type + : (-> Int Int Int))
(check-type (+ 1 2) : Int)
