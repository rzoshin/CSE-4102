%option noyywrap

%{
	#define INT_TYPE 1
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
%%

"//".*        { } 

"INT"       {yylval.int_val=INT_TYPE; return INT; }

"Suppose" { return SUPPOSE; }
"as"      {  return AS; }
"+"       { return ADDOP; }
"-"       { return SUBOP; }
"--"      { return DECR; }
"IN"      { return INPUT;}
"("       { return LPAREN; }
")"       { return RPAREN; }

";"       { return SEMI; }
"="       { return ASSIGN; }
"PRINT"   { return PRINT; }

{ID}        {strcpy(yylval.str_val, yytext); return ID;}
{ICONST}    {yylval.int_val=atoi(yytext); return ICONST;}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
