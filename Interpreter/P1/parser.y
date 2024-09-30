%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
    struct lbs *lbls;
}


%token ADDOP LT LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN PRINT

%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<lbls> WHILE

%left LT /*LT GT has lowest precedence*/
%left ADDOP


%type<int_val> exp assignment_print

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);};

code: statements;
statements: statements statement | ;
statement : declaration | assignment_print | while_stat;
declaration: INT ID SEMI
{
    insert($2, $1)
};
assignment_print: ID ASSIGN exp SEMI
{
    gen_code(STORE, idcheck($1));
}| PRINT LPAREN ID RPAREN SEMI
{
    gen_code(PRINT_INT_VALUE, idcheck($3));
};
while_stat: WHILE {$1 = (struct lbs*) newlblrec(); $1 -> for_goto= gen_label();}LPAREN exp RPAREN {
    $1 -> for_jmp_false = reserve_loc();
}LBRACE tail RBRACE{gen_code(GOTO, $1-> for_goto); back_patch($1-> for_jmp_false, JMP_FALSE, gen_label());}

tail: statements;
exp: ID
{
    gen_code(LD_VAR, idcheck($1));
}
| ICONST
{
    gen_code(LD_INT, $1);
}
| exp ADDOP exp {gen_code(ADD, -1)};
| exp LT exp {gen_code(LT_OP, -1)};

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

    printf("============= RUN CODE IN VIRTUAL MACHINE ===============\n");
    vm();

	return 0;
}
