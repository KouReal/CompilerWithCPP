#include"Manqua.h"
vector<Quadruple> Manqua::quatab;
int Manqua::curnum = 0;
ofstream Manqua::quafile("qua.out",ios::out);
/*
*Ôö¼ÓÒ»¸öËÄÔªÊ½
*/
int Manqua::addqua(Quadruple q)
{
	int idx = curnum+1;
	quatab.push_back(q);
	//output to the text.out
	if(q.opname != "print"){
		cout << q.opname << " " << q.op1 << " " << q.op2 << " " << q.res << endl;
		
		
	}
	else{
		cout << q.opname << " " << q.op1 << endl;
		
	}
	curnum++;
	return idx;
}
	
/*
*¸ù¾ÝËÄÔªÊ½±íÖÐµÄÐòºÅ·µ»ØÒ»¸öËÄÔªÊ½
*/
Quadruple & Manqua::getqua(int index)
{
	if(index>0 && index<=curnum){
		return quatab[index-1];
	}
	else{
		cout << "quadruple index out of range\n";
	}
}
void Manqua::outqua()
{
	Quadruple q;
	for(int i=0;i<quatab.size();++i){
		q=quatab[i];
		if(q.opname != "print"){
			quafile << q.opname << " " << q.op1 << " " << q.op2 << " " << q.res << endl;
		}
		else{
			quafile << q.opname << " " << q.op1 << endl;
		}
	}
}
