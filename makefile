result : parser.y scanner.l Manqua.cpp Manqua.h Manvar.cpp Manvar.h Nodeattr.cpp Nodeattr.h Quadruple.h Quadruple.cpp \
			Tempvar.cpp Tempvar.h Var.cpp Var.h allheader.h Execute.h
		bison -vdty parser.y
		flex scanner.l
		g++ -o res y.tab.c lex.yy.c Manqua.cpp Manvar.cpp Nodeattr.cpp Quadruple.cpp Tempvar.cpp Var.cpp Execute.cpp
.PHONY : clean
clean :
	rm -f res lex.yy.c y.tab.c y.output