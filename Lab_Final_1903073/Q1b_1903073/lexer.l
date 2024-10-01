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
FCONST    {digit}*"."{digit}+
CCONST    (\'{print}\')

%%

"//".*        { } 

"It's"       { return ITS; }
"proc"         { return PROC;}
"named"         { return NAMED;}
"main"         { return MAIN;}
"with"         { return WITH;}
"params"         { return PARAMS; }
"it"         { return IT;}
"starts"         { return STARTS;}
"from"         { return FROM;}
"here"         { return HERE;}
"an"         { return AN;}
"integer"       {yylval.int_val=INT_TYPE; return INT; }
"variable"      { return VARIABLE; }
"assign"         { return ASSIGN;}
"to"         { return TO;}
"and"         { return ANDD;}
"perform"         { return PERFORM;}
"between"    { return BETWEEN;}
"&"         { return AND;}
"add"         { return ADDOP;}
"store"         { return STOREE;}
"at"         { return AT;}
"display"   { return DISPLAY;}
"ends"     { return ENDS;}
"("       { return LPAREN; }
")"       { return RPAREN; }
";"       { return SEMI; }

{ID}        {strcpy(yylval.str_val, yytext); return ID;}
{ICONST}    {yylval.int_val=atoi(yytext); return ICONST;}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }
