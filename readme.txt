Allegro CL GTK+ Interface.

Introduction.

The files in this directory define an Allegro CL interface to GTK+
1.2.  GTK+ 2.0 is not supported by this release of the interface.

This interface is not meant to be regarded as a Lisp language binding
to GTK+.  Rather, it is a foreign function interface to the C binding
of GTK+.  To use this interface, you should be familiar with both the
Allegro CL foreign function interface and the C binding of GTK+.

GTK+ 1.2 is assumed already to be installed.  You can download GTK+
from the http://www.gtk.org web site.

Documentation.

GTK+ documentation can be found at the http://www.gtk.org web site.

There is no specific documentation for the Allegro CL GTK+ interface.
There are several examples in the interface's lispex/ subdirectory.
For the most part, these examples are line-by-line translations from C
to Lisp of the examples in the GTK+ tutorial.  These examples
demonstrate the various capabilities of GTK+ and how to use these
capabilities in Lisp via the Allegro CL GTK+ interface.  More
information about the examples can be found in lispex/readme.txt.

GTK+ Interface Usage.

To use the interface, you must be running Allegro CL 6.2 or later.
The LD_LIBRARY_PATH environment variable must include the directory
containing the GTK+ libraries.

Start Allegro CL and load the file "load.cl" in this directory.  Lisp
will automatically try to compile (if necessary) and then load the
appropriate files from the gtk directory (i.e., the directory
containing this readme.txt file).  If the file gtk-lib.so doesn't
already exist, Lisp will also automatically try to create gtk-lib.so.
This file is a shared-library file used to access the GTK+ libraries.

The lispex/ subdirectory contains examples.  Each can be loaded into
Lisp after load.cl has been loaded.  For more information on the
examples, see lispex/readme.txt.

Support.

This release of the Allegro CL GTK+ Interface is a work-in-progress.
It is being made available AS IS and not officially supported.  If you
have questions, comments, or suggestions about this interface, please
feel free to relay them to Franz Inc.  We welcome your input about
this release of the interface.

At the time of this writing, this interface has been targeted for the
Linux and Solaris 2 platforms only.

