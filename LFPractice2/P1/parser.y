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

%token LPAREN RPAREN LT PRINT ASSIGN ADDOP SEMI LBRACE RBRACE

%token<str_val> ID 
%token<int_val> INT
%token<int_val> ICONST
%token<int_val> WHILE


%left ADDOP

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements ;
statements: statements statement | ;
statement: declaration| assignment_print | while_stat

declaration: INT ID ASSIGN exp SEMI{
	insert($2,$1);
	int address = idcheck($2);
	gen_code(STORE, address)
};
while_stat: WHILE {$1 = gen_label(); gen_code(WHILE_LABEL, $1);} LPAREN exp RPAREN {gen_code(WHILE_START, $1);} tail { gen_code(WHILE_END, $1);};

tail: LBRACE statements RBRACE;

assignment_print: ID ASSIGN exp SEMI 
{
    int address = idcheck($1);
    if(address != -1)
    {
        gen_code(STORE, address);
    }
}| PRINT LPAREN ID RPAREN SEMI
{
            int address = idcheck($3);
            if(address != -1)
            {
                gen_code(PRINT_INT_VALUE, address);
            }
};
exp: ID 
{
    int address = idcheck($1);
    if(address!=-1)
    {
        gen_code(LD_VAR, address);
    }
}
| ICONST
{
    gen_code(LD_INT, $1);
}
| exp ADDOP exp {gen_code(ADD, -1);}
| exp LT exp { gen_code(LT_OP, gen_label()); };

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