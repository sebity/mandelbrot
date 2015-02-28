;;;; mandelbrot.lisp

(in-package #:mandelbrot)

;;; "mandelbrot" goes here. Hacks and glory await!

(defparameter *width* 800)
(defparameter *height* 600)
(defparameter *zoom* 0.35)
(defparameter *move-x* 1.5)
(defparameter *move-y* 1.4)
(defparameter *max-iterations* 300)


(defun square (x)
  (* x x))

(defun draw-fractal (width height zoom move-x move-y iter max-iter)
  (declare (type fixnum width height iter max-iter)
	   (type single-float zoom move-x move-y)
	   (optimize (speed 3) (safety 0) (debug 0)))
  (let* ((px-real 0.0)
	 (px-imag 0.0)
	 (new-real nil)
	 (new-imag nil)
	 (old-real nil)
	 (old-imag nil))
    (loop for dx fixnum below *width*
       do (loop for dy fixnum below *height*
	     do (setf px-real (+ (/ (* 1.5 (/ (float (- dx width)) 2.0))
				    (* 0.5 zoom (float width)))
				 move-x))
	       (setf px-imag (+ (/ (/ (float (- dy height)) 2.0)
				   (* 0.5 zoom height))
				move-y))
	       (setf new-real 0.0)
	       (setf new-imag 0.0)
	       (setf old-real 0.0)
	       (setf old-imag 0.0)
	       
	       (setf iter 0)

	       (loop do
		    (setf old-real new-real)
		    (setf old-imag new-imag)
		    
		    (setf new-real (+ (- (the single-float (square old-real))
					 (the single-float(square old-imag)))
				      px-real))
		    (setf new-imag (+ (the single-float (* 2.0 old-real old-imag))
				      (the single-float px-imag)))
		    
		    (setf iter (incf iter))
		    
		  while (and (< (+ (the single-float (square new-real))
				   (the single-float (square new-imag)))
				4)
			     (< iter max-iter)))
	       
	       (cond ((= iter max-iter)
		      (draw-pixel dx dy 0 0 0))
		     
		     ((< iter 16)
		      (draw-pixel dx dy (* iter 8.0) (* iter 8.0) (+ (* iter 4.0) 128)))
		     
		     ((and (> iter 16) (< iter 64))
		      (draw-pixel dx dy 
				  (- (+ 128 iter) 16) 
				  (- (+ 128 iter) 16)
				  (- (+ 192 iter) 16)))
		     
		     ((> iter 64)
		      (draw-pixel dx dy
				  (the fixnum (- max-iter iter))
				  (the fixnum (+ (- max-iter iter) 128))
				  (the fixnum (- max-iter iter)))))))))
	       

(defun draw-pixel (x y r g b)
  (declare (fixnum x y r g b)
	   (optimize (speed 3) (safety 0)))
  (sdl:draw-pixel-* x y :color (sdl:color :r r :g g :b b)))


(defun update-movement ()
  (setf *zoom* (* 1.001 *zoom*)))


(defun render ()
  ;(update-movement)
  (draw-fractal *width* *height* *zoom* *move-x* *move-y* 0 *max-iterations*)
  (sdl:update-display))

(defun start ()
  (sdl:with-init (sdl:sdl-init-video)
    (sdl:window *width* *height* :title-caption "Mandelbrot")
    (setf (sdl:frame-rate) 30)
    (sdl:clear-display sdl:*black*)

    (sdl:with-events ()
      (:quit-event () t)
      (:key-down-event (:key key)
		       (case key
			 (:sdl-key-escape (sdl:push-quit-event))))
      (:key-up-event (:key key)
		     (case key))
      (:idle ()
	     (render)))))
