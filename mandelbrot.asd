;;;; mandelbrot.asd

(asdf:defsystem #:mandelbrot
  :description "A Mandelbrot Set in Common Lisp"
  :author "Jan Tatham <jan@sebity.com>"
  :license "GPL v2"
  :depends-on (#:lispbuilder-sdl)
  :serial t
  :components ((:file "package")
               (:file "mandelbrot")))

