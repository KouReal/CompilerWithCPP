%{
#include"Nodeattr.h"
#define YYSTYPE Nodeattr
#include "y.tab.h"

int cur_line = 1;
void unrecognized_char(char c);
%}

/* note \042 is '"' */

INTEGER			(([1-9][0-9]*)|[0])
FLOAT			(([0]|([1-9][0-9]*))[.][0-9]*([eE][+-]?[0-9]*)?f?)
OPERATOR        ([-/+*(),;=])
IDENTIFIER      ([_a-zA-Z][_a-zA-Z0-9]*)
ROP				(([><])|(>=)|(<=)|(==)|(!=))
WHITESPACE      ([ \t]*)

%%
{OPERATOR}      { Nodeattr::setlitetext(&yylval,yytext);return yytext[0]; }
"int"           { Nodeattr::setlitetext(&yylval,yytext);return T_Int; }
"float"         { Nodeattr::setlitetext(&yylval,yytext);return T_Float; }
"print"			{ Nodeattr::setlitetext(&yylval,yytext);return PRINT; }
"if"			{ Nodeattr::setlitetext(&yylval,yytext);return IF;}
"then"			{ Nodeattr::setlitetext(&yylval,yytext);return THEN;}
"else"			{ Nodeattr::setlitetext(&yylval,yytext);return ELSE;}
"while"			{ Nodeattr::setlitetext(&yylval,yytext);return WHILE;}
"do"			{ Nodeattr::setlitetext(&yylval,yytext);return DO;}
"begin"			{ Nodeattr::setlitetext(&yylval,yytext);return BEG;}
"end"			{ Nodeattr::setlitetext(&yylval,yytext);return END;}
"{"				{ Nodeattr::setlitetext(&yylval,yytext);return BEG;}
"}"				{ Nodeattr::setlitetext(&yylval,yytext);return END;}
"&&"			{ Nodeattr::setlitetext(&yylval,yytext);return AND;}
"||"			{ Nodeattr::setlitetext(&yylval,yytext);return OR;}
"!"				{ Nodeattr::setlitetext(&yylval,yytext);return OPS;}

{ROP}			{ Nodeattr::setlitetext(&yylval,yytext);return Rop;}
{INTEGER}       { Nodeattr::setlitetext(&yylval,yytext);return V_Int; }
{FLOAT}			{ Nodeattr::setlitetext(&yylval,yytext);return V_Float; }
{IDENTIFIER}    { Nodeattr::setlitetext(&yylval,yytext);return Identifier;}
{WHITESPACE}    { /* ignore every whitespace */ }
\n              { cur_line++; }
.               { unrecognized_char(yytext[0]); }
%%

int yywrap(void) { 
    return 1;
}

void unrecognized_char(char c) {
    char buf[32] = "Unrecognized character: ?"; 
    puts(buf);
}
