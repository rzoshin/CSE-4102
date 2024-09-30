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
string    \"[^\"]+\"

ID        {alpha}{alnum}*
ICONST    [0-9]{digit}*

%%

"//".*        { }
"int"       {yylval.int_val=INT_TYPE; return INT; }
"while"     { return WHILE; }
"("       { return LPAREN; }
")"       { return RPAREN; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
"<"       { return LT; }
"print"   { return PRINT; }
"="       { return ASSIGN; }
"+"       { return ADDOP; }
";"       { return SEMI; }

{ID}        {strcpy(yylval.str_val, yytext); return ID;}
{ICONST}    {yylval.int_val=atoi(yytext); return ICONST;}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
