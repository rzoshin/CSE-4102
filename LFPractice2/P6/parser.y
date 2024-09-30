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

%token DEF OUT 
%token ADDOP
%token LPAREN RPAREN SEMI ASSIGN
%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT


%left LT
%left ADDOP 

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: l1 l2 l3 l4;
l1: DEF INT ID ASSIGN ICONST SEMI
{
    insert($3,$2);
    gen_code(LD_INT, $5);
    gen_code(STORE, idcheck($3));

};
l2: OUT LPAREN ID RPAREN SEMI
{
    gen_code(PRINT_INT_VALUE, idcheck($3));
};
l3: DEF INT ID ASSIGN ICONST SEMI
{
    insert($3,$2);
    gen_code(LD_INT, $5);
    gen_code(STORE, idcheck($3));
};
l4: OUT LPAREN ID ADDOP ID RPAREN SEMI
{
    gen_code(LD_VAR, idcheck($3));
    gen_code(LD_VAR, idcheck($5));
    gen_code(ADD, -1);
    insert("temp", INT_TYPE);
    gen_code(STORE, idcheck("temp"));
    gen_code(PRINT_INT_VALUE, idcheck("temp"));
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
