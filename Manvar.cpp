#include"allheader.h"
#include"Manvar.h"
//vartab变量表：
vector<Var> Manvar::vartab;
	
//varindex名字string作为索引方便之后以变量名查找变量的位置
map<string, int> Manvar::varindex;
	
//curnum 当前变量表的序号
int Manvar::curnum = 0;
/*
*增加新的变量
*/
int Manvar::addvar(Var &v)
{
	int index = curnum+1;
	vartab.push_back(v);
	varindex.insert(pair<string,int>(v.name,index));
	curnum++;
	return index;
}

/*
*以变量名查找变量的位置
*/
int Manvar::name2index(string name)
{
	int pos = 0;
	map<string,int>::iterator it;
	it = varindex.find(name);
	if(it != varindex.end()){
		pos = it->second;
	}
	return pos;
}
	
/*
*以变量位置返回变量Var
*/
Var& Manvar::index2var(int index)
{
	if(index>0 && index<=curnum){
		return vartab[index-1];
	}
	else{
		cout << "var index out of range\n";
	}
}

