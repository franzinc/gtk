;;
;; copyright (c) 1996-2000 Franz Inc, Berkeley, CA
;;
;; The software, data and information contained herein are proprietary
;; to, and comprise valuable trade secrets of, Franz, Inc.  They are
;; given in confidence by Franz, Inc. pursuant to a written license
;; agreement, and may be stored and used only in accordance with the terms
;; of such license.
;;
;; Restricted Rights Legend
;; ------------------------
;; Use, duplication, and disclosure of the software, data and information
;; contained herein by any agency, department or entity of the U.S.
;; Government are subject to restrictions of Restricted Rights for
;; Commercial Software developed at private expense as specified in 
;; DOD FAR Supplement 52.227-7013 (c) (1) (ii), as applicable.

;; $Id: load.cl,v 1.1.1.1 2002/02/20 20:11:39 cox Exp $

;;
;; Allegro CL GTK+ Interface loader.
;;
;; When loaded, this file attempts to load the Allegro CL GTK+ interface
;; which is assumed to be in the same directory as this file.
;;
;; Files being loaded are compiled first if necessary.  The main tricky area
;; is building/loading gtk-lib.so, the foreign stub file giving access to
;; the system GTK+ libraries.
;;
;; For building gtk-lib.so:
;; -- The gtk-config program must be available.
;; -- gtk libs must be in LD_LIBRARY_PATH when invoking the ld command.
;;
;; For loading gtk-lib.so:
;; -- gtk libs must be in LD_LIBRARY_PATH when Lisp is started.
;;
;; If gtk-lib.so is not found, Lisp restarts are used to help guide the user
;; towards building it.
;;

(in-package :excl)

(labels
    ((do-load (*default-pathname-defaults*)
       (do ((gtk-lib.so (merge-pathnames "gtk-lib.so"))
	    (gtk-lib.so-loaded nil))
	   (gtk-lib.so-loaded)		; end restart loop if success
	 (unless (probe-file gtk-lib.so)
	   (build-gtk-lib.so gtk-lib.so))
	 (restart-case			; rebuild gtk-lib.so if necessary
	     (handler-bind ((error #'(lambda (c)
				       (format t "~&~
~@<~@;Possible Error Cause: ~:I~
Lisp needs to be started with the directory including the gtk library ~
included in the LD_LIBRARY_PATH environment variable.~:@>~%"))))
	       (load gtk-lib.so)
	       (setq gtk-lib.so-loaded t))
	   (r-build-gtk-lib.so ()
	       :report (lambda (stream)
			 (format stream "Build ~a" (namestring gtk-lib.so)))
	     (build-gtk-lib.so gtk-lib.so))))

       (load (compile-file-if-needed "cdbind.cl")) ; From cbind
       (load (compile-file-if-needed "gtk.cl"))
       (load (compile-file-if-needed "eh.cl")))

     (build-gtk-lib.so (gtk-lib.so)
       ;; For building gtk-lib.so:
       ;; -- The gtk-config must be available.
       ;; -- gtk libs must be in LD_LIBRARY_PATH during ld.
       ;; 
       (do ((gtk-lib.so-built nil)
	    (gtk-config-path "")
	    (cmd nil))
	   (gtk-lib.so-built)		; end restart loop if success
	 (setq cmd (format nil "~
env LD_LIBRARY_PATH=~a ld ~a -o ~a `\"~agtk-config\" --libs | ~
sed 's/-rdynamic//'`"
			   (sys:getenv "LD_LIBRARY_PATH")
			   #+(or sparc aix) "-G"
			   #-(or sparc aix) "-shared"
			   (namestring gtk-lib.so)
			   gtk-config-path))
	 (format t "~&Command:~% ~s~%" cmd)
	 (restart-case			; specify gtk-config path if necessary
	     (if* (zerop (shell cmd))
		then (setq gtk-lib.so-built t)
		else (error "Build failed."))
	   (r-gtk-path (gtk-path-string)
	       :interactive read-new-value
	       :report (lambda (stream)
			 (format stream "~
~@<Retry building ~a by specifying the directory containing gtk-config.~:@>"
				 (namestring gtk-lib.so)))
	     (setq gtk-config-path
	       (concatenate 'string gtk-path-string "/")))
	   (r-add-to-ld-library-path (ld-path-string)
	       :report (lambda (stream)
			 (format stream "~
~@<Retry building ~a by adding a directory to LD_LIBRARY_PATH.~:@>"
				 (namestring gtk-lib.so)))
	       :interactive read-new-value
	     (let ((ld-path (sys:getenv "LD_LIBRARY_PATH")))
	       ;; Note that this doesn't affect dynamic loading
	       ;; in current process.
	       (setf (sys:getenv "LD_LIBRARY_PATH")
		 (concatenate 'string ld-path ":" ld-path-string)))))))

     (read-new-value ()
       (format t "Enter pathname namestring: ")
       (multiple-value-list (eval (read-line)))))

  (do-load *load-pathname*))
