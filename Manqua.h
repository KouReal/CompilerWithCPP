#pragma once
#include"allheader.h"
#include"Quadruple.h"
#include"Var.h"
class Manqua{
public :
	/*
	*增加一个四元式
	*curnum从1开始，0表示没有
	*/
	static int addqua(Quadruple q);
	
	/*
	*根据四元式表中的序号返回一个四元式
	*/
	static Quadruple & getqua(int index);
	static void outqua();
public :
	static vector<Quadruple> quatab;
	static int curnum;
	static ofstream quafile;
};