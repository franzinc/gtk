# $Id: Makefile,v 1.4 2005/08/03 05:07:56 layer Exp $

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
	-rm -fr gtk-dist build.tmp

FORCE:
