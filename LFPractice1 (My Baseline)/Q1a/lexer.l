%option noyywrap

%{
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

ID        {alpha}{alnum}*
ICONST    [0-9]{digit}*
FCONST    {digit}*"."{digit}+
CCONST    (\'{print}\')

%%

"//".*        { } 

"Sub"       { return SUB; }
"main"      { return MAIN; }
"("       { return LPAREN; }
")"       { return RPAREN; }
"Dim"       { return DIM; }
"As"        { return AS; } 
"Single"    { return SINGLE; }
"Integer"   { return INT; }
"End"     { return END; }
"="       { return ASSIGN; }
"+"       { return ADDOP; }
";"       { return SEMI; }

{ID}        {return ID;}
{ICONST}    {return ICONST;}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
%%