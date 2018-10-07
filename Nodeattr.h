#pragma once
#include"allheader.h"
class Nodeattr{
public :
	/*
	*
	*/
	static void setlitetext(Nodeattr *node,char *text);
	/*
	*合并真/假/出口链
	*/
	static int mergechain(int p1,int p2);
	
	/*
	*回填
	*/
	static void backpatch(int pc,int num);

	static void lookchain(int pc);
public :
	//定义变量的标识符
	string litetext;

	int loopstartplace;
	//定义变量或临时变量的序号
	int place;
	
	//变量的类型：int,float
	string type;
	
	//布尔表达式的真链和假链
	int truechain;
	int falsechain;
	
	//程序块的出口链
	int chain;
};