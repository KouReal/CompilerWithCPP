#pragma once
#include"allheader.h"
#include"Var.h"
class Tempvar{
public :
	/*
	*返回一个新的临时变量的标号，没有真实的变量入表
	*用于文法的四则运算中间结果的记录
	*/
	static int newtemp();
	/*
	*增加新的临时变量,返回一个负数(-1*curnum-1)
	*其绝对值是curnum+1
	*/
	static int addvar(Var v);
	
	/*
	*以索引位置返回临时变量
	*/
	static Var& index2var(int index);
public :
	static vector<Var> vartab;
	static int curnum;
};