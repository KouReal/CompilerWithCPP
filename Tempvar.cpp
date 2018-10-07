#include"Tempvar.h"
/*
*返回一个新的临时变量的标号，没有真实的变量入表
*用于文法的四则运算中间结果的记录
*/
vector<Var> Tempvar::vartab;
int Tempvar::curnum = 0;
int Tempvar::newtemp()
{
	int index = -1*curnum-1;
	//在vartab中占一个位置
	Var evar("","notype",0,0);
	vartab.push_back(evar);
	curnum++;
	return index;
}
/*
*增加新的临时变量,返回一个负数(-1*curnum-1)
*其绝对值是curnum+1
*/
int Tempvar::addvar(Var v)
{
	int index = -1*curnum-1;
	vartab.push_back(v);
	curnum++;
	return index;
}
	
/*
*以临时变量标号返回临时变量的引用（可以修改）
*/
Var& Tempvar::index2var(int index)
{
	int pos = -1*index - 1;
	if(pos >= 0 && pos < curnum){
		return vartab[pos];
	}
	else{
		cout << "tempvar index out of range\n";
	}
}
