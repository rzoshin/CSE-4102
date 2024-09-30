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

%token ELSE ADDOP SUBOP GT 
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN PRINT
%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> IF

%left GT
%left ADDOP SUBOP

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;

statements: statements statement | ;

statement:	assignment_print
            |if_statement
            ;


assignment_print: INT ID ASSIGN exp SEMI
                {
					insert($2, $1);
                    int address = idcheck($2);
                    if(address != -1)
                    {
                        gen_code(STORE, address);
                    }
                }
                | PRINT LPAREN ID RPAREN SEMI
                {
                    int address = idcheck($3);
                    if(address != -1)
                    {
                        gen_code(PRINT_INT_VALUE, address);
                    }
                }
                ;

exp: ICONST
{
    gen_code(LD_INT, $1);
}
    | ID
    {
        int address = idcheck($1);
        if(address!=-1)
        {
            gen_code(LD_VAR, address);
        }
    }
    | exp ADDOP exp {gen_code(ADD, -1);}
	| exp SUBOP exp {gen_code(SUB, -1);}
    | exp GT exp { gen_code(GT_OP, gen_label()); };

if_statement:
	IF {$1 = gen_label();} LPAREN exp RPAREN { gen_code(IF_START, $1); } tail ELSE { gen_code(ELSE_START, $1); } tail { gen_code(ELSE_END, $1); }
    ;

tail: LBRACE statements RBRACE 
    ;

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
