# $Id: Makefile,v 1.1.2.2 2002/07/10 00:13:05 cox Exp $

SHELL = sh

runlisp_sh = ../src/runlisp.sh
lisp = ../src/lisp -I dcl

all:	clean
	echo '(load "makedist.cl")' >> build.tmp
	echo '(exit 0)' >> build.tmp
	sh $(runlisp_sh) -f build.tmp $(lisp) -qq

clean: FORCE
	-find . -name '*.fasl' -print | xargs rm
	-find . -name '*.so' -print | xargs rm
	-rm -fr gtk-dist

FORCE:
