# $Id: Makefile,v 1.1.2.1 2002/02/27 16:43:58 layer Exp $

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
