%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
%}




%token ITS A PROC NAMED MAIN WITH PARAMS IT STARTS FROM HERE
%token AN INT VARIABLE ASSIGN TO PERFORM BETWEEN AND ADDOP STORE
%token AT DISPLAY ENDS LPAREN RPAREN SEMI ANDD
%token ID 
%token ICONST

%left ADDOP 

%start code

%%

code: statements ;
statements: l1 l2 l3 l4 l5 l6 l7 l8 l9;
l1: ITS A PROC NAMED MAIN WITH PARAMS LPAREN RPAREN;
l2: IT STARTS FROM HERE;
l3: ITS AN INT VARIABLE NAMED A SEMI;
l4: ITS AN INT VARIABLE NAMED ID SEMI;
l5: ASSIGN ICONST TO VARIABLE A SEMI;
l6: ASSIGN ICONST TO VARIABLE ID SEMI;
l7: PERFORM ADDOP BETWEEN A AND ID ANDD STORE AT ID SEMI;
l8: DISPLAY ID;
l9: IT ENDS HERE;

%%

void yyerror(const char *s)
{
	printf("Syntax error at line %d\n", lineno);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");	
	return 0;
}