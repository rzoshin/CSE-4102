%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror();
	extern int lineno;
	extern int yylex();
%}


%token SUB MAIN LPAREN RPAREN DIM AS SINGLE INTEGER END ASSIGN ADDOP SEMI INT
%token ID 
%token ICONST

%left ADDOP 

%start code

%%

code: SUB MAIN LPAREN RPAREN statements END SUB ;
statements: statements statement | ;
statement: declaration| assignment;
declaration : DIM ID AS type;
assignment : ID ASSIGN Exp;
Exp: ID ADDOP ID ADDOP ICONST SEMI 
    | ICONST ;
type: SINGLE | INT ;

%%

void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");	
	return 0;
}