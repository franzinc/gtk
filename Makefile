# $Id: Makefile,v 1.2 2002/04/10 23:56:38 cox Exp $

SHELL = sh

runlisp_sh = ../src/runlisp.sh
lisp = ../src/lisp -I dcl

all:	clean
	echo '(load "makedist.cl")' >> build.tmp
	echo '(exit 0)' >> build.tmp
	sh $(runlisp_sh) -f build.tmp $(lisp) -qq

clean: FORCE
	rm -fr gtk-dist

FORCE:
