#include"Execute.h"
ofstream Execute::exeout("calc.out",ios::out);
int Execute::curidx=1;
int Execute::quasize = 0;

Quadruple& Execute::idx2qua(int idx)
{
	if(idx>=1 && idx<=quasize){
		curidx++;
		return Manqua::quatab[idx-1];
	}
	else{
		#ifdef MYDEBUG
			cout << "Execute error : quaindex out of range : " << idx << endl;
		#endif
		exit(0);
	}
}
Var& Execute::idx2var(int idx)
{
	if(!idx){
		cout << "Execute error : var idx=0\n";
	}
	else{
		if(idx>0){
			return Manvar::index2var(idx);
		}
		else{
			return Tempvar::index2var(idx);
		}
	}
}
void Execute::calculate()
{
	//opname分为int和float和print
	//int   :  +i -i *i /i unmi =i
	//float :  +r -r *r /r unmr =r
	//类型转换 : itr rti
	//输出语句 : print
	quasize = Manqua::quatab.size();
	#ifdef MYDEBUG
		cout << "quasize : " << quasize << endl;
	#endif
	Quadruple tempqua;
	string opname;
	while(1){
		cout << "curidx : " << curidx << endl;
		if(curidx > quasize){
			break;
		}
		else{
			tempqua = idx2qua(curidx);
			opname = tempqua.opname;
		}
		if(tempqua.opname == "itr"){
			idx2var(tempqua.res).fv = idx2var(tempqua.op1).iv;
		}
		if(tempqua.opname == "rti"){
			idx2var(tempqua.res).iv = idx2var(tempqua.op1).fv;
		}
		if(tempqua.opname == "+i"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).iv = tv1.iv + tv2.iv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "-i"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).iv = tv1.iv - tv2.iv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "*i"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).iv = tv1.iv * tv2.iv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "/i"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).iv = tv1.iv / tv2.iv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "+r"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).fv = tv1.fv + tv2.fv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "-r"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).fv = tv1.fv - tv2.fv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "*r"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).fv = tv1.fv * tv2.fv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "/r"){
			if(tempqua.op1 && tempqua.op2 && tempqua.res){
				Var tv1 = idx2var(tempqua.op1);
				Var tv2 = idx2var(tempqua.op2);
				idx2var(tempqua.res).fv = tv1.fv / tv2.fv;

			}
			else{
				cout << "Execute error : operand = 0\n";
			}
		}
		if(tempqua.opname == "=i"){
			idx2var(tempqua.res).iv = idx2var(tempqua.op1).iv;
		}
		if(tempqua.opname == "=r"){
			idx2var(tempqua.res).fv = idx2var(tempqua.op1).fv;
		}
		if(tempqua.opname == "unmi"){
			idx2var(tempqua.res).iv = idx2var(tempqua.op1).iv * -1;
		}
		if(tempqua.opname == "unmr"){
			idx2var(tempqua.res).fv = idx2var(tempqua.op1).fv * -1;
		}
		if(tempqua.opname == "print"){
			Var v = idx2var(tempqua.op1);
			if(v.type == "int"){
				exeout << v.name << " = " << v.iv << endl;
			}
			else{
				exeout << v.name << " = " << v.fv << endl;
			}
		}
		if(tempqua.opname == "j"){
			curidx = tempqua.res;
		}
		if(tempqua.opname == "<"){
			Var v1 = idx2var(tempqua.op1);
			Var v2 = idx2var(tempqua.op2);
			string type1,type2;
			int ival1,ival2;
			float fval1,fval2;

			if(v1.iv){
				type1 = "int";
				ival1 = v1.iv;
			}
			else{
				if(v1.fv){
					type1 = "float";
					fval1 = v1.fv;
				}
				else{
					type1 = "int";
					ival1 = 0;
				}
			}
			if(v2.iv){
				type2 = "int";
				ival2 = v2.iv;
			}
			else{
				if(v2.fv){
					type2 = "float";
					fval2 = v2.fv;
				}
				else{
					type2 = "int";
					ival2 = 0;
				}
			}

			if(type1 == "int" && type2 == "int"){
				if(ival1 < ival2){
					curidx = tempqua.res;
				}
			}
			if(type1 == "int" && type2 == "float"){
				if(ival1 < fval2){
					curidx = tempqua.res;
				}
			}
			if(type1 == "float" && type2 == "int"){
				if(fval1 < ival2){
					curidx = tempqua.res;
				}
			}
			if(type1 == "float" && type2 == "float"){
				if(fval1 < fval2){
					curidx = tempqua.res;
				}
			}
		}
		if(tempqua.opname == ">"){
			Var v1 = idx2var(tempqua.op1);
			Var v2 = idx2var(tempqua.op2);
			string type1,type2;
			int ival1,ival2;
			float fval1,fval2;

			if(v1.iv){
				type1 = "int";
				ival1 = v1.iv;
			}
			else{
				if(v1.fv){
					type1 = "float";
					fval1 = v1.fv;
				}
				else{
					type1 = "int";
					ival1 = 0;
				}
			}
			if(v2.iv){
				type2 = "int";
				ival2 = v2.iv;
			}
			else{
				if(v2.fv){
					type2 = "float";
					fval2 = v2.fv;
				}
				else{
					type2 = "int";
					ival2 = 0;
				}
			}

			if(type1 == "int" && type2 == "int"){
				if(ival1 > ival2){
					curidx = tempqua.res;
				}
			}
			if(type1 == "int" && type2 == "float"){
				if(ival1 > fval2){
					curidx = tempqua.res;
				}
			}
			if(type1 == "float" && type2 == "int"){
				if(fval1 > ival2){
					curidx = tempqua.res;
				}
			}
			if(type1 == "float" && type2 == "float"){
				if(fval1 > fval2){
					curidx = tempqua.res;
				}
			}
		}
		
	}
}
