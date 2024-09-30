%option noyywrap

%{
	#define INT_TYPE 1
	#define REAL_TYPE 2
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "parser.tab.h"

	int lineno = 1; // initialize to 1
	void yyerror(const char *s);
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
print     [ -~]
string    \"[^\"]+\"

ID        {alpha}{alnum}*
ICONST    [0-9]{digit}*

%%

"//".*        { } 

"Integer"       {yylval.int_val=INT_TYPE; return INT; }
"Single"    {yylval.int_val=REAL_TYPE; return SINGLE; }

"Sub"       { return SUB; }
"main"      { return MAIN; }
"("       { return LPAREN; }
")"       { return RPAREN; }
"Dim"       { return DIM; }
"As"        { return AS; } 

"End"     { return END; }
"="       { return ASSIGN; }
"+"       { return ADDOP; }
";"       { return SEMI; }

{ID}        {strcpy(yylval.str_val, yytext); return ID;}
{ICONST}    {yylval.int_val=atoi(yytext); return ICONST;}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
