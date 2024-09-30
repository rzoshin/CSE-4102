%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "CodeGen.c"
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
    int offset;
%}

%union
{
    char str_val[100];
    int int_val;
}

%token SUPPOSE AS ASSIGN DECR SEMI PRINT LPAREN RPAREN INPUT ADDOP SUBOP

%token<str_val> ID exp
%token<int_val> ICONST
%token<int_val> INT

%left LT GT
%left ADDOP 

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;
statements: l1 l2 l3 ;
l1: SUPPOSE ID AS INT ASSIGN ICONST DECR SEMI
{
    insert($2, $4);
    gen_code(LD_INT, $6);
    gen_code(LD_INT, 1);
    gen_code(SUB, -1);
    gen_code(STORE, idcheck($2));
};
l2: SUPPOSE ID AS INT ASSIGN PRINT LPAREN INPUT LPAREN RPAREN SUBOP ID ADDOP ICONST RPAREN SEMI
{
    insert($2, $4);
    gen_code(SCAN_INT_VALUE, idcheck($2));
    gen_code(LD_VAR, idcheck($2));
    gen_code(LD_VAR, idcheck($12));
    gen_code(SUB, -1);
    gen_code(LD_INT, $14);
    gen_code(ADD, -1);
    gen_code(STORE, idcheck($2));
};
l3: PRINT LPAREN ID RPAREN SEMI
{
    gen_code(PRINT_INT_VALUE, idcheck($3));
};
%%

void yyerror(const char *s)
{
	printf("Syntax error at line %d\n", lineno);
}

int main()
{
	yyparse();
	printf("Parsing finished!\n");

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}
