
SHELL = sh

runlisp_sh = ../src/runlisp.sh
lisp = ../src/lisp -I dcl

all:	clean
	echo '(load "makedist.cl")' >> build.tmp
	echo '(exit 0)' >> build.tmp
	bash $(runlisp_sh) -f build.tmp $(lisp) -qq

build:	clean
	echo '(load "loadgtk20.cl")' >> build.tmp
	echo '(exit 0)' >> build.tmp
	bash $(runlisp_sh) -f build.tmp $(lisp) -qq

clean: FORCE
	-find . -name '*.fasl' -print | xargs rm -f
	-find . -name '*.so' -print | xargs rm -f
	-find . -name '*.dylib' -print | xargs rm -f
	-rm -fr gtk-dist build.tmp

FORCE:
