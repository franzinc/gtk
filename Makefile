# $Id: Makefile,v 1.5 2005/09/28 21:45:13 layer Exp $

SHELL = sh

runlisp_sh = ../src/runlisp.sh
lisp = ../src/lisp -I dcl

all:	clean
	echo '(load "makedist.cl")' >> build.tmp
	echo '(exit 0)' >> build.tmp
	sh $(runlisp_sh) -f build.tmp $(lisp) -qq

clean: FORCE
	-find . -name '*.fasl' -print | xargs rm -f
	-find . -name '*.so' -print | xargs rm -f
	-rm -fr gtk-dist build.tmp

FORCE:
