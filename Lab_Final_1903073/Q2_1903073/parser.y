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
    char *str_val;
    int int_val;
}

%token ITS PROC NAMED MAIN WITH PARAMS IT STARTS FROM HERE
%token AN VARIABLE ASSIGN TO PERFORM BETWEEN AND ADDOP STOREE
%token AT DISPLAY ENDS LPAREN RPAREN SEMI ANDD
%token CHECK GT IF TRUE FALSE

%token<str_val> ID
%token<str_val> DISP_STRING
%token<int_val> ICONST
%token<int_val> INT

%left ADDOP 

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements ;
statements: l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12;
l1: ITS ID PROC NAMED MAIN WITH PARAMS LPAREN RPAREN;
l2: IT STARTS FROM HERE;
l3: ITS AN INT VARIABLE NAMED ID SEMI
{
	insert($6, $3);
};
l4: ITS AN INT VARIABLE NAMED ID SEMI
{
	insert($6, $3);
};
l5: ASSIGN ICONST TO VARIABLE ID SEMI
{
	gen_code(LD_INT, $2);
	gen_code(STORE, idcheck($5));
};

l6: ASSIGN ICONST TO VARIABLE ID SEMI
{
	gen_code(LD_INT, $2);
	gen_code(STORE, idcheck($5));
};

l7: PERFORM ADDOP BETWEEN ID AND ID ANDD STOREE AT ID SEMI
{
	gen_code(LD_VAR, idcheck($4));
	gen_code(LD_VAR, idcheck($6));
	gen_code(ADD, -1);
	gen_code(STORE, idcheck($10));
};

l8: CHECK ID GT ICONST IF TRUE
{
	offset = gen_label();
	gen_code(LD_VAR, idcheck($2));
	gen_code(LD_INT, $4);
	gen_code(GT_OP, gen_label());
	gen_code(IF_START, offset);

};

l9: DISPLAY DISP_STRING SEMI
{
	gen_code(PRINT_OK_VALUE, 0);
};
l10: IF FALSE
{
	gen_code(ELSE_START, offset);
};
l11: DISPLAY DISP_STRING SEMI
{
	gen_code(PRINT_NOT_OK_VALUE, 0);
	gen_code(ELSE_END, offset);
};
l12: IT ENDS HERE;

%%

void yyerror(const char *s)
{
	printf("Syntax error at line %d\n", lineno);
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