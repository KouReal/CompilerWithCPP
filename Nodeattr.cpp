#include"Nodeattr.h"
#include"Manqua.h"


void Nodeattr::setlitetext(Nodeattr *node,char *text)
{
	node->litetext = text;
}
/*
*合并真/假/出口链
*/
int Nodeattr::mergechain(int p1,int p2)
{
	if(!p2){
		#ifdef MYDEBUG
			cout << "in mergechain : p2=0" << endl;
		#endif
		return p1;
	}
	else{
		#ifdef MYDEBUG
			cout << "in mergechain : p2!=0" << endl;
			cout << "look p2 : " << endl;
			lookchain(p2);
		#endif
		int p = p2;
		while(Manqua::getqua(p).res){
			p = Manqua::getqua(p).res;
		}
		//因为getqua返回的是Quadruple的引用，可以直接修改res
		(Manqua::getqua(p)).res = p1;
		return p2;
	}
}
	
/*
*回填
*/
void Nodeattr::backpatch(int pc,int num)
{
	#ifdef MYDEBUG
		cout << "in backpatch : " << endl;
		cout << "look pc\n";
		lookchain(pc);
	#endif
	int q = pc;
	while(q){
		int q1 = Manqua::getqua(q).res;
		Manqua::getqua(q).res = num;
		q = q1;
	}
}
void Nodeattr::lookchain(int pc)
{
	cout << "in lookchain\n";
	int q=pc;
	while(q){
		cout << "chain: " << q << endl;
		q=Manqua::getqua(q).res;
	}
}