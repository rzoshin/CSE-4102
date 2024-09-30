%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "CodeGen.c"
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
	int offset1;
	int offset2;
%}

%union
{
    char str_val[100];
    int int_val;
}

%token SUB MAIN LPAREN RPAREN DIM AS END ASSIGN ADDOP SEMI
%token NEXT TO THEN GT PRINT

%token<str_val> ID 
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> FOR
%token<int_val> IF
%token<int_val> SINGLE


%left ADDOP 

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: SUB MAIN LPAREN RPAREN statements END SUB ;
statements: l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11;
l1: DIM ID AS SINGLE{
	insert($2, $4)
};
l2: DIM ID AS INT{
	insert($2, $4)
};
l3:ID ASSIGN EXP {
	gen_code(STORE, idcheck($1));
};
l4: l3;
l5: l3;
l6: FOR ID ASSIGN ICONST TO ICONST
{
	$1 = gen_label(); 
	gen_code(WHILE_LABEL, $1); 
	offset1 = $1;
	gen_code(LD_VAR, idcheck($2));
	gen_code(LD_INT, $6);
	gen_code(LTE_OP, gen_label());
	gen_code(WHILE_START, offset1);
};
l7: l3;
EXP: EXP SEMI|
ID
{
	gen_code(LD_VAR, idcheck($1));
}
| ICONST
{
	gen_code(LD_INT, $1);
}
| EXP ADDOP EXP
{
	gen_code(ADD, -1);
};
l8: NEXT ID{
	gen_code(LD_VAR, idcheck($2));
	gen_code(LD_INT, 1);
	gen_code(ADD, -1);
	gen_code(STORE, idcheck($2));
	gen_code(WHILE_END, offset1);
};
l9: IF ID GT ICONST THEN{
	$1 = gen_label();
	offset2 = $1;
	gen_code(LD_VAR, idcheck($2));
	gen_code(LD_INT, $4);
	gen_code(GT_OP, gen_label());
	gen_code(IF_START, offset2);
};
l10: PRINT LPAREN ID RPAREN{
	gen_code(PRINT_INT_VALUE, idcheck($3));
	gen_code(ELSE_START, offset2);
	gen_code(ELSE_END, offset2);
}
l11: END IF
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