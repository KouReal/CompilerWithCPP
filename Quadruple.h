#pragma once
#include"allheader.h"
class Quadruple{
public :
	Quadruple();
	Quadruple(string on,int o1,int o2,int r);
public :
	//opname分为int和float和print
	//int   :  +i -i *i /i unmi =i
	//float :  +r -r *r /r unmr =r
	//类型转换 : itr rti
	//输出语句 : print
	string opname;
	
	//op1/2等于0表示为空
	int op1;
	int op2;
	int res;
};