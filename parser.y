%{
#include"Nodeattr.h"
#define YYSTYPE Nodeattr
#include"allheader.h"
#include"Manvar.h"
#include"Manqua.h"
#include"Quadruple.h"
#include"Var.h"
#include"Tempvar.h"
#include"Execute.h"

void yyerror(const char* msg) {}
extern int yylex(void);
int curstmtnum = 1;
%}

%token T_Int T_Float V_Int V_Float Identifier PRINT IF THEN ELSE WHILE DO BEG END Rop AND OR OPS
%left '+' '-'
%left '*' '/'
%right UNMINUS
%%

Series:   
    Stmt                        
{ 
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.chain = $1.chain;
	curstmtnum++; 
	#ifdef MYDEBUG
		cout << "Series:Stmt : " << endl;
		cout << "$$.chain =$1chain : " <<$$.chain << endl;
	#endif
}
|   Series Stmt                     
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.chain = $2.chain;
    curstmtnum++; 
    int NXQ = Manqua::curnum+1;
    Nodeattr::backpatch($2.chain,NXQ);
    #ifdef MYDEBUG
		cout << "Series:Series Stmt : " << endl;
		cout << "backpatch : $2.chain : " << $2.chain << " to " << NXQ << endl;
		cout << "$$.chain =$2chain : " <<$$.chain << endl;
	#endif
}
;

Stmt:
    Decl ';'  
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
		cout << "Stmt:Decl\n";
	#endif
	$$.chain = 0;
}                  
|   Assign ';'  
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
		cout << "Stmt:Assign\n";
	#endif
	$$.chain = 0;
}                
|	Print ';'	
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
		cout << "Stmt:Print; \n";
	#endif
	$$.chain = 0;
}				
|	BEG Series END 			
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
		cout << "Stmt:BEG Series END\n";
	#endif
	$$.chain = $2.chain;
}
;

Decl:
	Type Init
{	
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	#ifdef MYDEBUG
		cout << "Decl:Type Init : " << $1.type << " " << $2.litetext << endl;
	#endif
	if($1.type == "int"){
		Var v($2.litetext,"int",0,0);
		int idx = Manvar::addvar(v);
		
		if($2.place == 0){
			
			/*empty*/
		}
		else{
			
			if($2.type == "int"){
				
				Quadruple qua("=i",$2.place,0,idx);
				Manqua::addqua(qua);
			}
			else{
				int temp = Tempvar::newtemp();
				Quadruple qua1("rti",$2.place,0,temp);
				Manqua::addqua(qua1);
				Quadruple qua2("=i",temp,0,idx);
				Manqua::addqua(qua2);
			}
		}
		$$.type = "int";
	}
	else{
		Var v($2.litetext,"float",0,0);
		int idx = Manvar::addvar(v);
		if($2.place == 0){
			/*empty*/
		}
		else{
			if($2.type == "float"){
				Quadruple qua("=r",$2.place,0,idx);
				Manqua::addqua(qua);
			}
			else{
				int temp = Tempvar::newtemp();
				Quadruple qua1("itr",$2.place,0,temp);
				Manqua::addqua(qua1);
				Quadruple qua2("=r",temp,0,idx);
				Manqua::addqua(qua2);
			}
		}
		$$.type = "float";
	}
}
|   Decl ',' Init
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	#ifdef MYDEBUG
		cout << "Decl:Decl,Init : " << $3.litetext << " " << $3.place << endl;
	#endif
	if($1.type == "int"){
		Var v($3.litetext,"int",0,0);
		int idx = Manvar::addvar(v);
		
		if($3.place == 0){
			/*empty*/
		}
		else{
			if($3.type == "int"){
				Quadruple qua("=i",$3.place,0,idx);
				Manqua::addqua(qua);
			}
			else{
				int temp = Tempvar::newtemp();
				Quadruple qua1("rti",$3.place,0,temp);
				Manqua::addqua(qua1);
				Quadruple qua2("=i",temp,0,idx);
				Manqua::addqua(qua2);
			}
		}
		$$.type = "int";
	}
	else{
		Var v($3.litetext,"float",0,0);
		int idx = Manvar::addvar(v);
		if($3.place == 0){
			/*empty*/
		}
		else{
			if($3.type == "float"){
				Quadruple qua("=r",$3.place,0,idx);
				Manqua::addqua(qua);
			}
			else{
				int temp = Tempvar::newtemp();
				Quadruple qua1("itr",$3.place,0,temp);
				Manqua::addqua(qua1);
				Quadruple qua2("=r",temp,0,idx);
				Manqua::addqua(qua2);
			}
		}
		$$.type = "float";
	}
}
;

Init:
	Identifier
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.litetext = $1.litetext;
	$$.place = 0;
	#ifdef MYDEBUG
		cout << "Init:Identifier : " << $1.litetext << endl;
	#endif
}
|	Identifier '=' E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.litetext = $1.litetext;
	$$.place = $3.place;
	$$.type = $3.type;
	#ifdef MYDEBUG
		cout << "Init:Identifier=E : " << $1.litetext << " " << $3.place << endl;
	#endif
}
;

Type:
	T_Int
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.type = "int";
	#ifdef MYDEBUG
		cout << "Type:T_Int : " << "int" << endl;
	#endif
}
|	T_Float
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.type = "float";
	#ifdef MYDEBUG
		cout << "Type:T_Float : " << "float" << endl;
	#endif
}
;

Assign:
    Identifier '=' E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	#ifdef MYDEBUG
		cout << "Assign:Identifier=E : " << $1.litetext << " " << $3.place << endl;
	#endif
	int idx = Manvar::name2index($1.litetext);
	if(!idx){
		cout << "error in stmt " << curstmtnum << " : ";
		cout << "cannot find identifier : " << $1.litetext << endl;
		exit(0);
	}
	else{
		string idtype = Manvar::index2var(idx).type;
		if(idtype == "int" && $3.type == "int"){
			Quadruple qua("=i",$3.place,0,idx);
			Manqua::addqua(qua);
			$$.place = idx;
			$$.type = "int";
		}
		if(idtype == "float" && $3.type == "float"){
			Quadruple qua("=r",$3.place,0,idx);
			Manqua::addqua(qua);
			$$.place = idx;
			$$.type = "int";
		}
		if(idtype == "int" && $3.type == "float"){
			int temp = Tempvar::newtemp();
			Quadruple qua1("rti",$3.place,0,temp);
			Manqua::addqua(qua1);
			Quadruple qua2("=i",temp,0,idx);
			Manqua::addqua(qua2);
			$$.place = idx;
			$$.type = "int";
		}
		if(idtype == "float" && $3.type == "int"){
			int temp = Tempvar::newtemp();
			Quadruple qua1("itr",$3.place,0,temp);
			Manqua::addqua(qua1);
			Quadruple qua2("=r",temp,0,idx);
			Manqua::addqua(qua2);
			$$.place = idx;
			$$.type = "float";
		}
	}
}
|	Assign ',' Identifier '=' E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	#ifdef MYDEBUG
		cout << "Assign:Assign,Identifier=E : " << $3.litetext << " " << $5.place << endl;
	#endif
	int idx = Manvar::name2index($3.litetext);
	if(!idx){
		cout << "error in stmt " << curstmtnum << " : ";
		cout << "cannot find identifier : " << $3.litetext << endl;
		exit(0);
	}
	else{
		string idtype = Manvar::index2var(idx).type;
		if(idtype == "int" && $5.type == "int"){
			Quadruple qua("=i",$5.place,0,idx);
			Manqua::addqua(qua);
			$$.place = idx;
			$$.type = "int";
		}
		if(idtype == "float" && $5.type == "float"){
			Quadruple qua("=r",$5.place,0,idx);
			Manqua::addqua(qua);
			$$.place = idx;
			$$.type = "int";
		}
		if(idtype == "int" && $5.type == "float"){
			int temp = Tempvar::newtemp();
			Quadruple qua1("rti",$5.place,0,temp);
			Manqua::addqua(qua1);
			Quadruple qua2("=i",temp,0,idx);
			Manqua::addqua(qua2);
			$$.place = idx;
			$$.type = "int";
		}
		if(idtype == "float" && $5.type == "int"){
			int temp = Tempvar::newtemp();
			Quadruple qua1("itr",$5.place,0,temp);
			Manqua::addqua(qua1);
			Quadruple qua2("=r",temp,0,idx);
			Manqua::addqua(qua2);
			$$.place = idx;
			$$.type = "float";
		}
	}
}
;

Print:	
	PRINT Identifier
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	int idx = Manvar::name2index($2.litetext);
	if(!idx){
		cout << "error in stmt " << curstmtnum << " : ";
		cout << "cannot find identifier : " << $2.litetext << endl;
		exit(0);
	}
	else{
		Quadruple qua("print",idx,0,0);
		Manqua::addqua(qua);
	}
}
;

E:
    E '+' E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	if($1.type == "int" && $3.type == "int"){
		int temp = Tempvar::newtemp();
		Quadruple qua("+i",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "int";
		$$.place = temp;
	}
	if($1.type == "float" && $3.type == "float"){
		int temp = Tempvar::newtemp();
		Quadruple qua("+r",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "float";
		$$.place = temp;
	}
	if($1.type == "int" && $3.type == "float"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$1.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("+r",temp1,$3.place,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
	if($1.type == "float" && $3.type == "int"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$3.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("+r",$1.place,temp1,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
}	
|   E '-' E 
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	if($1.type == "int" && $3.type == "int"){
		int temp = Tempvar::newtemp();
		Quadruple qua("-i",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "int";
		$$.place = temp;
	}
	if($1.type == "float" && $3.type == "float"){
		int temp = Tempvar::newtemp();
		Quadruple qua("-r",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "float";
		$$.place = temp;
	}
	if($1.type == "int" && $3.type == "float"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$1.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("-r",temp1,$3.place,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
	if($1.type == "float" && $3.type == "int"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$3.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("-r",$1.place,temp1,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
}                    
|   E '*' E        
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	if($1.type == "int" && $3.type == "int"){
		int temp = Tempvar::newtemp();
		Quadruple qua("*i",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "int";
		$$.place = temp;
	}
	if($1.type == "float" && $3.type == "float"){
		int temp = Tempvar::newtemp();
		Quadruple qua("*r",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "float";
		$$.place = temp;
	}
	if($1.type == "int" && $3.type == "float"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$1.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("*r",temp1,$3.place,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
	if($1.type == "float" && $3.type == "int"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$3.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("*r",$1.place,temp1,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
}             
|   E '/' E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	if($1.type == "int" && $3.type == "int"){
		int temp = Tempvar::newtemp();
		Quadruple qua("/i",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "int";
		$$.place = temp;
	}
	if($1.type == "float" && $3.type == "float"){
		int temp = Tempvar::newtemp();
		Quadruple qua("/r",$1.place,$3.place,temp);
		Manqua::addqua(qua);
		$$.type = "float";
		$$.place = temp;
	}
	if($1.type == "int" && $3.type == "float"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$1.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("/r",temp1,$3.place,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
	if($1.type == "float" && $3.type == "int"){
		int temp1 = Tempvar::newtemp();
		Quadruple qua1("itr",$3.place,0,temp1);
		Manqua::addqua(qua1);
		int temp2 = Tempvar::newtemp();
		Quadruple qua2("/r",$1.place,temp1,temp2);
		Manqua::addqua(qua2);
		$$.place = temp2;
		$$.type = "float";
	}
}                     
|   '-' E %prec UNMINUS     
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	if($2.type == "int"){
		int temp = Tempvar::newtemp();
		Quadruple qua("unmi",$2.place,0,temp);
		Manqua::addqua(qua);
		$$.place = temp;
		$$.type = "int";
	}
	else{
		int temp = Tempvar::newtemp();
		Quadruple qua("unmr",$2.place,0,temp);
		Manqua::addqua(qua);
		$$.place = temp;
		$$.type = "float";
	}
}   
|   V_Int	
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	Var temp_ivar("","int",atoi($1.litetext.c_str()),atoi($1.litetext.c_str()));
	$$.place = Tempvar::addvar(temp_ivar);
	$$.type = "int";
	#ifdef MYDEBUG
		cout << "E:V_Int : " << $1.litetext << " " << $$.place << endl;
	#endif
}	                
|	V_Float		
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	
	Var temp_fvar("","float",atof($1.litetext.c_str()),atof($1.litetext.c_str()));
	$$.place = Tempvar::addvar(temp_fvar);
	$$.type = "float";
	#ifdef MYDEBUG
		cout << "E:V_Float : " << $1.litetext << " " << $$.place << endl;
	#endif
}				
|   Identifier
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	#ifdef MYDEBUG
		cout << "E:Identifier : " << $1.litetext << endl;
	#endif

	int idx = Manvar::name2index($1.litetext);
	if(!idx){
		cout << "error in stmt " << curstmtnum << " : ";
		cout << "cannot find identifier : " << $1.litetext << endl;
		exit(0);
	}
	else{
		$$.place = idx;
		$$.type = (Manvar::index2var(idx)).type;
	}
}                  
|   '(' E ')'
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.place = $2.place;
	$$.type = $2.type;
}
;

Condition :
	IF BoolExp THEN
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	int NXQ = Manqua::curnum + 1;
	Nodeattr::backpatch($2.truechain,NXQ);
	$$.chain = $2.falsechain;
	#ifdef MYDEBUG
		cout << "Condition:IF BoolExp THEN : \n";
		cout << "backpatch $2.truechain (head) : " << $2.truechain << " to " << NXQ << endl;
		cout << "$$.chain : " << $$.chain << endl;
	#endif
}
;

Stmt :
	Condition Stmt
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.chain = Nodeattr::mergechain($1.chain,$2.chain);
	#ifdef MYDEBUG
		cout << "Stmt:Condition Stmt: \n";
		cout << "mergechain : $1.chain $2.chain : "<<$1.chain << " " << $2.chain << endl;
		cout << "$$.chain : " << $$.chain << endl;
	#endif
}
;

CondStElse :
	Condition Stmt ELSE
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	int q = Manqua::curnum + 1;
	Quadruple qua("j",0,0,0);
	Manqua::addqua(qua);
	Nodeattr::backpatch($1.chain,q+1);
	$$.chain = Nodeattr::mergechain($2.chain,q);
	#ifdef MYDEBUG
		cout << "CondStElse:Condition Stmt ELSE \n";
		cout << "backpatch $1.chain (head) : " << $1.chain << " to " << q+1 << endl;
		cout << "mergechain : $1.chain $2.chain : " << $1.chain << $2.chain << endl;
		cout << "$$.chain = merge result : " << $$.chain << endl;
	#endif
}
;

Stmt :
	CondStElse Stmt
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.chain = Nodeattr::mergechain($1.chain,$2.chain);
	#ifdef MYDEBUG
		cout << "Stmt:Condition Stmt \n";
		cout << "mergechain :1 2 .chain : " << $1.chain << " " << $2.chain << endl;
		cout << "$$.chain = merge result : " << $$.chain << endl;
	#endif
}
;

Wl :
	WHILE
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.loopstartplace = Manqua::curnum + 1;
	#ifdef MYDEBUG
		cout << "Wl:WHILE\n";
		cout << "$$.loopstartplace : " << $$.loopstartplace << endl;
	#endif
}
;

WED :
	Wl BoolExp DO
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	int NXQ = Manqua::curnum + 1;
	Nodeattr::backpatch($2.truechain,NXQ);
	$$.chain = $2.falsechain;
	$$.loopstartplace = $1.loopstartplace;
	#ifdef MYDEBUG
		cout << "WED:Wl BoolExp DO\n";
		cout << "backpatch : $2.truechain : " << $2.truechain << " to " << NXQ << endl;
		cout << "$$.chain = $2.falsechain : " << $$.chain << endl;
		cout << "loopstart : " << $1.loopstartplace << endl;
	#endif
}
;

Stmt :
	WED Stmt
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	Nodeattr::backpatch($2.chain,$1.loopstartplace);
	Quadruple qua("j",0,0,$1.loopstartplace);
	Manqua::addqua(qua);
	$$.chain = $1.chain;
	#ifdef MYDEBUG
		cout << "Stmt:WED Stmt\n";
		cout << "backpatch : $2.chain : " << $2.chain << " to " << $1.loopstartplace << endl;
		cout << "$$.chain =  $1chain ; " << $$.chain << endl;
	#endif
}
;




BoolExp :
	E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	#ifdef MYDEBUG
		cout << "BoolExp:E : " << $1.place << endl;
	#endif
	Quadruple qua1("jnz",$1.place,0,0);
	$$.truechain = Manqua::addqua(qua1);
	Quadruple qua2("j",0,0,0);
	$$.falsechain = Manqua::addqua(qua2);
}
|	E Rop E
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	Quadruple qua1($2.litetext,$1.place,$3.place,0);
	$$.truechain = Manqua::addqua(qua1);
	Quadruple qua2("j",0,0,0);
	$$.falsechain = Manqua::addqua(qua2);
	#ifdef MYDEBUG
		cout << "BoolExp:E Rop E : " << $1.place << " " << $3.place << endl;
		cout << "truechain: " << $$.truechain << endl;
		cout << "falsechain: " << $$.falsechain << endl;
	#endif
}
|	'(' BoolExp ')'
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.truechain = $2.truechain;
	$$.falsechain = $2.falsechain;
	#ifdef MYDEBUG
		cout << "BoolExp:( BoolExp ) : " << $2.place << endl;
		cout << "truechain: " << $$.truechain << endl;
		cout << "falsechain: " << $$.falsechain << endl;
	#endif
}
|	OPS BoolExp
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.truechain = $2.falsechain;
	$$.falsechain = $2.truechain;
	#ifdef MYDEBUG
		cout << "BoolExp:OPS BoolExp : " << $2.place << endl;
		cout << "truechain: " << $$.truechain << endl;
		cout << "falsechain: " << $$.falsechain << endl;
	#endif
}
|	BEAND BoolExp
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.truechain = $2.truechain;
	$$.falsechain = Nodeattr::mergechain($1.falsechain,$2.falsechain);
	#ifdef MYDEBUG
		cout << "BoolExp:BEAND BoolExp : " << $2.place << endl;
		cout << "truechain: " << $$.truechain << endl;
		cout << "falsechain: " << $$.falsechain << endl;
	#endif
}
|	BEOR BoolExp
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	$$.falsechain = $2.falsechain;
	$$.truechain = Nodeattr::mergechain($1.truechain,$2.truechain);
	#ifdef MYDEBUG
		cout << "BoolExp:BEOR BoolExp : " << $2.place << endl;
		cout << "truechain: " << $$.truechain << endl;
		cout << "falsechain: " << $$.falsechain << endl;
	#endif
}
;
BEAND :
	BoolExp AND
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	int NXQ = Manqua::curnum + 1;
	Nodeattr::backpatch($1.truechain,NXQ);
	$$.falsechain = $1.falsechain;
	#ifdef MYDEBUG
		cout << "BoolExp:BoolExp AND : " << $1.place << endl;
		cout << "falsechain: " << $$.falsechain << endl;
	#endif
}
;
BEOR :
	BoolExp OR
{
	#ifdef MYDEBUG
		cout << "-----------------------------------\n";
	#endif
	int NXQ = Manqua::curnum + 1;
	Nodeattr::backpatch($1.falsechain,NXQ);
	$$.truechain = $1.truechain;
	#ifdef MYDEBUG
		cout << "BoolExp:BoolExp OR : " << $1.place << endl;
		cout << "truechain: " << $$.truechain << endl;
	#endif
}
;

%%

int main() {
	freopen("text.in", "rt+", stdin);
	freopen("text.out", "wt+", stdout);
	yyparse();
	Manqua::outqua();
	#ifdef MYDEBUG
		cout << "-------------------start debug Execute::calculate()\n";
	#endif
	Execute::calculate();
}