%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "CodeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token SUB MAIN LPAREN RPAREN DIM AS END ASSIGN ADDOP SEMI

%token<str_val> ID 
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> SINGLE

%type<int_val> type

%left ADDOP 

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: SUB MAIN LPAREN RPAREN statements END SUB ;
statements: statements statement | ;
statement: declaration| assignment;
declaration : DIM ID AS type
{
	insert($2,$4);
};
assignment : ID ASSIGN ID ADDOP ID ADDOP ICONST SEMI 
{
	int address1 = idcheck($1);
	int address2 = idcheck($3);
	int address3 = idcheck($5);
	gen_code(LD_VAR, address2);
	gen_code(LD_VAR, address3);
	gen_code(ADD, -1);
	gen_code(LD_INT, $7);
	gen_code(ADD, -1);
	gen_code(STORE, address1);
}| ID ASSIGN ICONST
{
	int address = idcheck($1);
	gen_code(LD_INT, $3);
	gen_code(STORE, address)
};
type: SINGLE {
	$$ = REAL_TYPE;
}| INT {
	$$ = INT_TYPE;
};

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

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}