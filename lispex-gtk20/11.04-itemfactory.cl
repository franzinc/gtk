;#include <gtk/gtk.h>
;#include <strings.h>
;
;/* Obligatory basic callback */
;static void print_hello( GtkWidget *w,
;			  gpointer   data )
;{
;  g_message ("Hello, World!\n");
;}
;
;/* This is the GtkItemFactoryEntry structure used to generate new menus.
;   Item 1: The menu path. The letter after the underscore indicates an
;	    accelerator key once the menu is open.
;   Item 2: The accelerator key for the entry
;   Item 3: The callback function.
;   Item 4: The callback action.  This changes the parameters with
;	    which the function is called.  The default is 0.
;   Item 5: The item type, used to define what kind of an item it is.
;	    Here are the possible values:
;
;	    NULL               -> "<Item>"
;	    ""                 -> "<Item>"
;	    "<Title>"          -> create a title item
;	    "<Item>"           -> create a simple item
;	    "<CheckItem>"      -> create a check item
;	    "<ToggleItem>"     -> create a toggle item
;	    "<RadioItem>"      -> create a radio item
;	    <path>             -> path of a radio item to link against
;	    "<Separator>"      -> create a separator
;	    "<Branch>"         -> create an item to hold sub items (optional)
;	    "<LastBranch>"     -> create a right justified branch 
;*/
;
;static GtkItemFactoryEntry menu_items[] = {
;  { "/_File",         NULL,         NULL, 0, "<Branch>" },
;  { "/File/_New",     "<control>N", print_hello, 0, NULL },
;  { "/File/_Open",    "<control>O", print_hello, 0, NULL },
;  { "/File/_Save",    "<control>S", print_hello, 0, NULL },
;  { "/File/Save _As", NULL,         NULL, 0, NULL },
;  { "/File/sep1",     NULL,         NULL, 0, "<Separator>" },
;  { "/File/Quit",     "<control>Q", gtk_main_quit, 0, NULL },
;  { "/_Options",      NULL,         NULL, 0, "<Branch>" },
;  { "/Options/Test",  NULL,         NULL, 0, NULL },
;  { "/_Help",         NULL,         NULL, 0, "<LastBranch>" },
;  { "/_Help/About",   NULL,         NULL, 0, NULL },
;};
;
;
;void get_main_menu( GtkWidget  *window,
;		     GtkWidget **menubar )
;{
;  GtkItemFactory *item_factory;
;  GtkAccelGroup *accel_group;
;  gint nmenu_items = sizeof (menu_items) / sizeof (menu_items[0]);
;
;  accel_group = gtk_accel_group_new ();
;
;  /* This function initializes the item factory.
;     Param 1: The type of menu - can be GTK_TYPE_MENU_BAR, GTK_TYPE_MENU,
;	       or GTK_TYPE_OPTION_MENU.
;     Param 2: The path of the menu.
;     Param 3: A pointer to a gtk_accel_group.  The item factory sets up
;	       the accelerator table while generating menus.
;  */
;
;  item_factory = gtk_item_factory_new (GTK_TYPE_MENU_BAR, "<main>", 
;					accel_group);
;
;  /* This function generates the menu items. Pass the item factory,
;     the number of items in the array, the array itself, and any
;     callback data for the the menu items. */
;  gtk_item_factory_create_items (item_factory, nmenu_items, menu_items, NULL);
;
;  /* Attach the new accelerator group to the window. */
;  gtk_window_add_accel_group (GTK_WINDOW (window), accel_group);
;
;  if (menubar)
;    /* Finally, return the actual menu bar created by the item factory. */ 
;    *menubar = gtk_item_factory_get_widget (item_factory, "<main>");
;}
;
;int main( int argc,
;	   char *argv[] )
;{
;  GtkWidget *window;
;  GtkWidget *main_vbox;
;  GtkWidget *menubar;
;  
;  gtk_init (&argc, &argv);
;  
;  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
;  g_signal_connect (G_OBJECT (window), "destroy", 
;		     G_CALLBACK (gtk_main_quit), 
;		     NULL);
;  gtk_window_set_title (GTK_WINDOW (window), "Item Factory");
;  gtk_widget_set_size_request (GTK_WIDGET (window), 300, 200);
;  
;  main_vbox = gtk_vbox_new (FALSE, 1);
;  gtk_container_set_border_width (GTK_CONTAINER (main_vbox), 1);
;  gtk_container_add (GTK_CONTAINER (window), main_vbox);
;  gtk_widget_show (main_vbox);
;  
;  get_main_menu (window, &menubar);
;  gtk_box_pack_start (GTK_BOX (main_vbox), menubar, FALSE, TRUE, 0);
;  gtk_widget_show (menubar);
;  
;  gtk_widget_show (window);
;
;  gtk_main ();
;  
;  return 0;
;}

(defpackage "11.04-itemfactory" (:use :excl :common-lisp))
(in-package "11.04-itemfactory")


(ff:defun-foreign-callable print-hello ((w (* gtk:GtkWidget))
					(data gtk:gpointer))
  (declare (ignore w data))
  (format t "Message: Hello, World!~%"))

(defun lists-to-gtk-item-factory-entries (lists &aux (lg (length lists)))
  (let ((entries (ff:allocate-fobject (list ':array 'gtk:GtkItemFactoryEntry
					    lg)
				      :foreign-static-gc))
	(i 0))
    (dolist (list-entry lists entries)
      (let ((entry (ff:fslot-value-typed '(:array gtk:GtkItemFactoryEntry) nil
					 entries i)))
	(setf (ff:fslot-value-typed 'gtk:GtkItemFactoryEntry nil entry
				    'gtk::path)
	  (string-to-native (first list-entry)))
	(setf (ff:fslot-value-typed 'gtk:GtkItemFactoryEntry nil entry
				    'gtk::accelerator)
	  (if* (stringp (second list-entry))
	     then (string-to-native (second list-entry))
	     else (second list-entry)))
	(setf (ff:fslot-value-typed 'gtk:GtkItemFactoryEntry nil entry
				    'gtk::callback)
	  (third list-entry))
	(setf (ff:fslot-value-typed 'gtk:GtkItemFactoryEntry nil entry
				    'gtk::callback_action)
	  (if* (stringp (fourth list-entry))
	     then (string-to-native (fourth list-entry))
	     else (fourth list-entry)))
	(setf (ff:fslot-value-typed 'gtk:GtkItemFactoryEntry nil entry
				    'gtk::item_type)
	  (if* (stringp (fifth list-entry))
	     then (string-to-native (fifth list-entry))
	     else (fifth list-entry))))
      (incf i))))
				    
(ff:defun-foreign-callable cb-gtk-main-quit ()
  (gtk:gtk-main-quit))

(defparameter menu-items
    (let ((print-hello (ff:register-foreign-callable 'print-hello))
	  (gtk_main_quit
	   #+original (ff:get-entry-point "gtk_main_quit")
	   #-original (ff:register-foreign-callable 'cb-gtk-main-quit)))
      (list (list "/_File" gtk:NULL gtk:NULL 0 "<Branch>")
	    (list "/File/_New" "<control>N" print-hello 0 gtk:NULL)
	    (list "/File/_Open" "<control>O" print-hello 0 gtk:NULL)
	    (list "/File/_Save" "<control>S" print-hello 0 gtk:NULL)
	    (list "/File/Save _As" gtk:NULL gtk:NULL 0 gtk:NULL)
	    (list "/File/sep1" gtk:NULL gtk:NULL 0 "<Separator>")
	    (list "/File/Quit" "<control>Q" gtk_main_quit 0 gtk:NULL)
	    (list "/_Options" gtk:NULL gtk:NULL 0 "<Branch>")
	    (list "/Options/Test" gtk:NULL gtk:NULL 0 gtk:NULL)
	    (list "/_Help" gtk:NULL gtk:NULL 0 "<LastBranch>")
	    (list "/_Help/About" gtk:NULL gtk:NULL 0 gtk:NULL))))

(defun get-main-menu (window)
  (let ((item-factory nil)
	(accel-group nil)
	(nmenu-items (length menu-items)))

    (setq accel-group (gtk:gtk_accel_group_new))

    (setq item-factory (gtk:gtk_item_factory_new gtk:GTK_TYPE_MENU_BAR
						 "<main>" accel-group))
    (gtk:gtk_item_factory_create_items item-factory nmenu-items
				       (lists-to-gtk-item-factory-entries
					menu-items)
				       gtk:NULL)
    (gtk:gtk_window_add_accel_group (gtk:GTK_WINDOW window) accel-group)

    (gtk:gtk_item_factory_get_widget item-factory "<main>")))

(defun itemfactory ()
  (let ((window nil)
	(main-vbox nil)
	(menubar nil))
    (gtk:gtk_init 0 0)

    (setq window (gtk:gtk_window_new gtk:GTK_WINDOW_TOPLEVEL))
    (gtk:g_signal_connect (gtk:G_OBJECT window) "destroy"  
			  (gtk:G_CALLBACK
			   #+original (ff:get-entry-point "gtk_main_quit")
			   #-original (ff:register-foreign-callable
				       'cb-gtk-main-quit))
			  "WM destroy")
    (gtk:gtk_window_set_title (gtk:GTK_WINDOW window) "Item Factory")
    (gtk:gtk_widget_set_size_request (gtk:GTK_WIDGET window) 300 200)

    (setq main-vbox (gtk:gtk_vbox_new gtk:FALSE 1))
    (gtk:gtk_container_set_border_width (gtk:GTK_CONTAINER main-vbox) 1)
    (gtk:gtk_container_add (gtk:GTK_CONTAINER window) main-vbox)
    (gtk:gtk_widget_show main-vbox)

    (setq menubar (get-main-menu window))
    (gtk:gtk_box_pack_start (gtk:GTK_BOX main-vbox) menubar gtk:FALSE gtk:TRUE
			    0)
    (gtk:gtk_widget_show menubar)

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
  (run-example "11.04-itemfactory" #'itemfactory))
