(in-package :excl)

(flet ((makedist (*default-pathname-defaults*
		  &aux (gtk-dist (merge-pathnames #p"gtk-dist/")))
	 (delete-directory-and-files gtk-dist)
	 
	 (dolist (file '(
			 #p"cdbind.cl"
			 #p"eh.cl"
			 #p"gtk.cl"
			 #p"load.cl"
			 #p"readme.txt"
			 #p"lispex/readme.txt"
			 #p"lispex/02.00-base.cl"
			 #p"lispex/02.01-helloworld.cl"
			 #p"lispex/03.03-helloworld2.cl"
			 #p"lispex/04.03-packbox.cl"
			 #p"lispex/04.05-table.cl"
			 #p"lispex/06.01-buttons.cl"
			 #p"lispex/06.04-radiobuttons.cl"
			 #p"lispex/08.05-rangewidgets.cl"
			 #p"lispex/09.01-label.cl"
			 #p"lispex/09.02-arrow.cl"
			 #p"lispex/09.04-progressbar.cl"
			 #p"lispex/09.06-pixmap.cl"
			 #p"lispex/09.06-wheelbarrow.cl"
			 #p"lispex/09.07-rulers.cl"
			 #p"lispex/09.08-statusbar.cl"
			 #p"lispex/09.09-entry.cl"
			 #p"lispex/09.10-spinbuttons.cl"
			 #p"lispex/09.12-calendar.cl"
			 #p"lispex/09.13-colorsel.cl"
			 #p"lispex/09.14-filesel.cl"
			 #p"lispex/10.01-eventbox.cl"
			 #p"lispex/10.03-fixed.cl"
			 #p"lispex/10.05-frame.cl"
			 #p"lispex/10.06-aspectframe.cl"
			 #p"lispex/10.07-paned.cl"
			 #p"lispex/10.09-scrolledwin.cl"
			 #p"lispex/10.10-buttonbox.cl"
			 #p"lispex/10.12-notebook.cl"
			 #p"lispex/11.10-clist.cl"
			 #p"lispex/13.06-tree.cl"
			 #p"lispex/14.02-menu.cl"
			 #p"lispex/14.04-itemfactory.cl"
			 #p"lispex/15.04-text.cl"
			 #p"lispex/20.02-gettargets.cl"
			 #p"lispex/20.03-setselection.cl"
			 ))
	   (ensure-directories-exist (merge-pathnames file gtk-dist))
	   (print (merge-pathnames file gtk-dist))
	   (sys:copy-file (merge-pathnames file)
			  (merge-pathnames file gtk-dist)))))
  (makedist
   (merge-pathnames (make-pathname :name :unspecific :type :unspecific)
		    *load-pathname*)))
