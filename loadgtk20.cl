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

;; $Id: loadgtk20.cl,v 1.1.2.1 2002/04/12 00:17:38 cox Exp $

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
;; -- The pkg-config (or gtk-config) program must be available.
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
       (do ((gtk-lib.so (merge-pathnames "gtk20-lib.so"))
	    (gtk-lib.so-loaded nil))
	   (gtk-lib.so-loaded)		; end restart loop if success
	 (unless (probe-file gtk-lib.so)
	   (build-gtk-lib.so gtk-lib.so))
	 (restart-case			; rebuild gtk-lib.so if necessary
	     (handler-bind ((error #'(lambda (c)
				       (declare (ignore c))
				       (format t "~&~
~@<~@;Possible Error Cause: ~:I~
Lisp needs to be started with the LD_LIBRARY_PATH environment variable ~
including the gtk library path.~:@>~%"))))
	       (load gtk-lib.so)
	       (setq gtk-lib.so-loaded t))
	   (r-build-gtk-lib.so ()
	       :report (lambda (stream)
			 (format stream "Build ~a" (namestring gtk-lib.so)))
	     (build-gtk-lib.so gtk-lib.so))))

       (load (compile-file-if-needed "cdbind.cl")) ; From cbind
       (load (compile-file-if-needed "gtk20.cl"))
       (load (compile-file-if-needed "eh.cl")))

     (build-gtk-lib.so (gtk-lib.so
			&aux (config-prog "pkg-config")
			     (config-arg "gtk+-2.0"))
       ;; For building gtk-lib.so:
       ;; -- The pkg-config (or gtk-config) must be available.
       ;; -- gtk libs must be in LD_LIBRARY_PATH during ld.
       ;; 
       (do ((gtk-lib.so-built nil)
	    (pkg-config-path "")
	    (cmd nil))
	   (gtk-lib.so-built)		; end restart loop if success
	 (setq cmd (format nil "~
env LD_LIBRARY_PATH=~a ld ~a -o ~a ~
`\"~a~a\" --libs ~a | ~
sed 's/-rdynamic//'`"
			   (sys:getenv "LD_LIBRARY_PATH")
			   #+(or sparc aix) "-G"
			   #-(or sparc aix) "-shared"
			   (namestring gtk-lib.so)
			   pkg-config-path
			   config-prog
			   config-arg))
	 (format t "~&Command:~% ~s~%" cmd)
	 (restart-case			; specify config-prog path if necessary
	     (if* (zerop (shell cmd))
		then (setq gtk-lib.so-built t)
		else (error "Build failed."))
	   (r-gtk-path (gtk-path-string)
	       :interactive read-new-value
	       :report (lambda (stream)
			 (format stream "~
~@<Retry building ~a by specifying the directory containing ~a~:@>"
				 (namestring gtk-lib.so)
				 config-prog))
	     (setq pkg-config-path
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

  (let ((*record-source-file-info* nil)
	(*load-source-file-info* nil))
    (do-load *load-pathname*)))
