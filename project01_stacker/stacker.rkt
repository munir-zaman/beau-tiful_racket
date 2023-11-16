#lang br/quicklang

#|
    As the first step in running a source file with a #lang line,
    Racket passes the source code to the reader for the language.
    It does this by invoking a func­tion called, by conven­tion, read-syntax.
    Every reader must export a read-syntax func­tion. Racket passes two argu­ments to read-syntax:
    the path to the source file, and a port for reading data from the file.
|#

(define (read-syntax path port)
    (define src-lines (port->lines port))
    #|format datum... + -> (handle +) ~a is placeholder|#
    (define src-datums (format-datums '(handle ~a) src-lines))
    #|
        "`" is a quasi-quote.. meaning you can substitute variables using ",".. 
        and also substitute multiple variables using ",@"|#
    (define module-datum `(module stacker-mod "stacker.rkt" ,@src-datums))
    (datum->syntax #f module-datum))

#|

    We also need to export read-syntax so it’s avail­able outside this file. 
    In Racket, all defi­n­i­tions are private by default. 
    To make a defi­n­i­tion public, we use provide
|#
(provide read-syntax)

(define-macro (stacker-module-begine HANDLE-EXPR ...)
    #'(#%module-begin 'HANDLE-EXPR ...))

(provide (rename-out [stacker-module-begine #%module-begin]))