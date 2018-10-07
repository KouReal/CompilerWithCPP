#include"allheader.h"
#include"Manqua.h"
#include"Manvar.h"
#include"Tempvar.h"
#include"Nodeattr.h"
class Execute{
public:
	static Quadruple& idx2qua(int idx);
	static void calculate();
	static Var& idx2var(int idx);
public:
	static ofstream exeout;
	static int curidx;
	static int quasize;
};