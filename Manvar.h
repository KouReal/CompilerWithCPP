#pragma once
#include"allheader.h"
#include"Var.h"
class Manvar{
public :
	/*
	*增加新的变量
	*将源程序中的字面值以临时变量存到vartab中
	*返回变量的索引
	*/
	static int addvar(Var &v);
	
	/*
	*以变量名查找变量的位置
	*返回0表示没有找到
	*/
	static int name2index(string name);
	
	/*
	*以变量位置返回变量Var,index从1开始，0表示不存在
	*/
	static Var& index2var(int index);
	
public :
	//vartab变量表：
	static vector<Var> vartab;
	
	//varindex名字string作为索引方便之后以变量名查找变量的位置
    static map<string, int> varindex;
	
	//curnum 当前变量表的序号从0开始
	static int curnum;
};