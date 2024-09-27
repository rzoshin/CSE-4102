%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token PRINT ELSE SCAN
%token ADDOP LT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> IF
%token<int_val> WHILE

%left LT
%left ADDOP 

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;

statements: statements statement | ;

statement:  declaration
            |assignment_print_scan 
            |while_statement
            |if_statement
            ;

declaration: INT ID SEMI{
    insert($2, $1);
};

assignment_print_scan: ID ASSIGN exp SEMI
                {
                    int address = idcheck($1);
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
                | SCAN LPAREN ID RPAREN SEMI
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
    | exp LT exp { gen_code(LT_OP, gen_label()); };

if_statement:
	IF {$1 = gen_label();} LPAREN exp RPAREN { gen_code(IF_START, $1); } tail ELSE { gen_code(ELSE_START, $1); } tail { gen_code(ELSE_END, $1); }
    ;

tail: LBRACE statements RBRACE 
    ;

while_statement: WHILE {$1 = gen_label(); gen_code(WHILE_LABEL, $1);}LPAREN exp RPAREN {gen_code(WHILE_START, $1);}tail { gen_code(WHILE_END, $1);};
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
