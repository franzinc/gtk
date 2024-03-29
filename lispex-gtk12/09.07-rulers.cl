;/* example-start rulers rulers.c */
;
;#include <gtk/gtk.h>
;
;#define EVENT_METHOD(i, x) GTK_WIDGET_CLASS(GTK_OBJECT(i)->klass)->x
;
;#define XSIZE  600
;#define YSIZE  400
;
;/* This routine gets control when the close button is clicked */
;gint close_application( GtkWidget *widget,
;			 GdkEvent  *event,
;			 gpointer   data )
;{
;    gtk_main_quit();
;    return(FALSE);
;}
;
;/* The main routine */
;int main( int   argc,
;	   char *argv[] ) {
;    GtkWidget *window, *table, *area, *hrule, *vrule;
;
;    /* Initialize GTK and create the main window */
;    gtk_init( &argc, &argv );
;
;    window = gtk_window_new( GTK_WINDOW_TOPLEVEL );
;    gtk_signal_connect (GTK_OBJECT (window), "delete_event",
;	     GTK_SIGNAL_FUNC( close_application ), NULL);
;    gtk_container_set_border_width (GTK_CONTAINER (window), 10);
;
;    /* Create a table for placing the ruler and the drawing area */
;    table = gtk_table_new( 3, 2, FALSE );
;    gtk_container_add( GTK_CONTAINER(window), table );
;
;    area = gtk_drawing_area_new();
;    gtk_drawing_area_size( (GtkDrawingArea *)area, XSIZE, YSIZE );
;    gtk_table_attach( GTK_TABLE(table), area, 1, 2, 1, 2,
;		       GTK_EXPAND|GTK_FILL, GTK_FILL, 0, 0 );
;    gtk_widget_set_events( area, GDK_POINTER_MOTION_MASK |
;				  GDK_POINTER_MOTION_HINT_MASK );
;
;    /* The horizontal ruler goes on top. As the mouse moves across the
;     * drawing area, a motion_notify_event is passed to the
;     * appropriate event handler for the ruler. */
;    hrule = gtk_hruler_new();
;    gtk_ruler_set_metric( GTK_RULER(hrule), GTK_PIXELS );
;    gtk_ruler_set_range( GTK_RULER(hrule), 7, 13, 0, 20 );
;    gtk_signal_connect_object( GTK_OBJECT(area), "motion_notify_event",
;				(GtkSignalFunc)EVENT_METHOD(hrule,
;							 motion_notify_event),
;				GTK_OBJECT(hrule) );
;    /*  GTK_WIDGET_CLASS(GTK_OBJECT(hrule)->klass)->motion_notify_event, */
;    gtk_table_attach( GTK_TABLE(table), hrule, 1, 2, 0, 1,
;		       GTK_EXPAND|GTK_SHRINK|GTK_FILL, GTK_FILL, 0, 0 );
;    
;    /* The vertical ruler goes on the left. As the mouse moves across
;     * the drawing area, a motion_notify_event is passed to the
;     * appropriate event handler for the ruler. */
;    vrule = gtk_vruler_new();
;    gtk_ruler_set_metric( GTK_RULER(vrule), GTK_PIXELS );
;    gtk_ruler_set_range( GTK_RULER(vrule), 0, YSIZE, 10, YSIZE );
;    gtk_signal_connect_object( GTK_OBJECT(area), "motion_notify_event",
;				(GtkSignalFunc)
;				   GTK_WIDGET_CLASS(GTK_OBJECT(vrule)->klass)->
;							  motion_notify_event,
;				GTK_OBJECT(vrule) );
;    gtk_table_attach( GTK_TABLE(table), vrule, 0, 1, 1, 2,
;		       GTK_FILL, GTK_EXPAND|GTK_SHRINK|GTK_FILL, 0, 0 );
;
;    /* Now show everything */
;    gtk_widget_show( area );
;    gtk_widget_show( hrule );
;    gtk_widget_show( vrule );
;    gtk_widget_show( table );
;    gtk_widget_show( window );
;    gtk_main();
;
;    return(0);
;}
;/* example-end */


(defpackage "09.07-rulers" (:use :excl :common-lisp))
(in-package "09.07-rulers")

(defmacro event-method (i x)
  `(ff:fslot-value-typed
    'gtk:GtkWidgetClass nil
    (gtk:GTK_WIDGET_CLASS
     (ff:fslot-value-typed 'gtk:GtkObject nil (gtk:GTK_OBJECT ,i) 'gtk::klass))
    ,x))

(defconstant *xsize* 600)
(defconstant *ysize* 400)

(ff:defun-foreign-callable close-application ((widget (* gtk:GtkWidget))
					      (event (* gtk:GdkEvent))
					      (data gtk:gpointer))
  (declare (ignore widget event data))
  #+original (gtk:gtk_main_quit)
  #-original (gtk:gtk-main-quit)
  gtk:FALSE)

(defun rulers ()
  (let ((window nil)
	(table nil)
	(area nil)
	(hrule nil)
	(vrule nil))

    (gtk:gtk_init 0 0)

    (setq window (gtk:gtk_window_new gtk:GTK_WINDOW_TOPLEVEL))
    (gtk:gtk_signal_connect (gtk:GTK_OBJECT window) "delete_event"
			    (gtk:GTK_SIGNAL_FUNC
			     (ff:register-foreign-callable 'close-application))
			    gtk:NULL)
    (gtk:gtk_container_set_border_width (gtk:GTK_CONTAINER window) 10)

    (setq table (gtk:gtk_table_new 3 2 gtk:FALSE))
    (gtk:gtk_container_add (gtk:GTK_CONTAINER window) table)

    (setq area (gtk:gtk_drawing_area_new))
    (gtk:gtk_drawing_area_size area *xsize* *ysize*)
    (gtk:gtk_table_attach (gtk:GTK_TABLE table) area 1 2 1 2
			  (logior gtk:GTK_EXPAND gtk:GTK_FILL)
			  gtk:GTK_FILL 0 0)
    (gtk:gtk_widget_set_events area (logior gtk:GDK_POINTER_MOTION_MASK
					    gtk:GDK_POINTER_MOTION_HINT_MASK))

    (setq hrule (gtk:gtk_hruler_new))
    (gtk:gtk_ruler_set_metric (gtk:GTK_RULER hrule) gtk:GTK_PIXELS)
    (gtk:gtk_ruler_set_range (gtk:GTK_RULER hrule) 7.0 13.0 0.0 20.0)
    (gtk:gtk_signal_connect_object (gtk:GTK_OBJECT area) "motion_notify_event"
				   (event-method hrule
						 'gtk::motion_notify_event)
				   (gtk:GTK_OBJECT hrule))
    (gtk:gtk_table_attach (gtk:GTK_TABLE table) hrule 1 2 0 1
			  (logior gtk:GTK_EXPAND gtk:GTK_SHRINK gtk:GTK_FILL)
			  gtk:GTK_FILL 0 0)

    (setq vrule (gtk:gtk_vruler_new))
    (gtk:gtk_ruler_set_metric (gtk:GTK_RULER vrule) gtk:GTK_PIXELS)
    (gtk:gtk_ruler_set_range (gtk:GTK_RULER vrule) 0.0 (float *ysize*) 10.0
			     (float *ysize*))
    (gtk:gtk_signal_connect_object (gtk:GTK_OBJECT area) "motion_notify_event"
				   (ff:fslot-value-typed
				    'gtk:GtkWidgetClass nil
				    (gtk:GTK_WIDGET_CLASS
				     (ff:fslot-value-typed
				      'gtk:GtkObject nil
				      (gtk:GTK_OBJECT vrule)
				      'gtk::klass))
				    'gtk::motion_notify_event)
				   (gtk:GTK_OBJECT vrule))
    (gtk:gtk_table_attach (gtk:GTK_TABLE table) vrule 0 1 1 2
			  gtk:GTK_FILL
			  (logior gtk:GTK_EXPAND gtk:GTK_SHRINK gtk:GTK_FILL)
			  0 0)

    (gtk:gtk_widget_show area)
    (gtk:gtk_widget_show hrule)
    (gtk:gtk_widget_show vrule)
    (gtk:gtk_widget_show table)
    (gtk:gtk_widget_show window)
    #+original (gtk:gtk_main)
    #-original (gtk:gtk-main)))


(flet ((run-example (name function)
	 ;; workaround for bogus (imo) redef. warnings generated by defvar
	 (declare (special gtk::*run-example*))
	 (unless (boundp 'gtk::*run-example*)
	   (setq gtk::*run-example* t))
	 (when gtk::*run-example*
	   (mp:process-run-function
	    (format nil "GTK+ Example: ~a" name)
	    function))))
  (run-example "09.07-rulers" #'rulers))
