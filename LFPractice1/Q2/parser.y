%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "CodeGen.c"
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
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

%type<int_val> type
%left ADDOP 

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: SUB MAIN LPAREN RPAREN statements END SUB ;
statements: statements statement | ;
statement: declaration| assignment | For_stat | If_stat ;
For_stat: FOR {$1 = gen_label(); gen_code(WHILE_LABEL, $1);} Cond1 { gen_code(WHILE_START, $1);} For_asign Next_stat { gen_code(WHILE_END, $1);};
For_asign: ID ASSIGN ID ADDOP ICONST{
	int address1 = idcheck($1);
	int address2 = idcheck($3);
	gen_code(LD_VAR, address2);
	gen_code(LD_INT, $5);
	gen_code(ADD, -1);
	gen_code(STORE, address1);
};
Cond1: ID ASSIGN ICONST TO ICONST{
	int address = idcheck($1);
	gen_code(LD_VAR, address);
	gen_code(LD_INT, $5);
	gen_code(LT_OP, gen_label());
};
Next_stat: NEXT ID{
	int address = idcheck($2);
	if (address!= -1)
	{
		gen_code(LD_INT, 1);
		gen_code(LD_VAR, address);
		gen_code(ADD, -1);
		gen_code(STORE, address);
	}
};
If_stat: IF {$1 = gen_label();} Cond2 { gen_code(IF_START, $1); } THEN Print_stat END IF{ gen_code(ELSE_END, $1); };
Cond2: ID GT ICONST{
	int address = idcheck($1);
	gen_code(LD_VAR, address);
	gen_code(LD_INT, $3);
	gen_code(GT_OP, gen_label());
};
Print_stat: PRINT LPAREN ID RPAREN
{
	int address = idcheck($3);
	gen_code(PRINT_INT_VALUE, address)
};
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