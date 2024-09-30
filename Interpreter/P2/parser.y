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
    struct lbs *lbls;
}

%token PRINT
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN ELSE
%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<lbls> IF

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP SUBOP 
%left MULOP /*MULOP has lowest precedence*/

%type<int_val> exp assignment_print_scan

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);};

code: statements;

statements: statements statement | ;

statement: declaration
        | assignment_print
        | if_statement
        ;

declaration: INT ID SEMI
            {
                insert($2, $1);
            };

assignment_print: ID ASSIGN exp SEMI
                    {
                        int address = idcheck($1);

                        if(address !=-1)
                        {
                            gen_code(STORE, address);
                        }                        
                    }
                    | PRINT LPAREN ID RPAREN SEMI
                    {
                        int address = idcheck($3);

                        if(address !=-1)
                        {
                            gen_code(PRINT_INT_VALUE, address);
                        }
                    };

if_statement:   IF LPAREN exp RPAREN 
                {
                    $1 = (struct lbs *) newlblrec(); 
                    $1->for_jmp_false = reserve_loc();
                }     
                tail { $1->for_goto = reserve_loc(); } 
                ELSE 
                {
                    back_patch( $1->for_jmp_false, JMP_FALSE, gen_label() ); 
                }    
                tail
                { 
                    back_patch( $1->for_goto, GOTO, gen_label() ); 
                }
                ;


tail: LBRACE statements RBRACE 
    ;

exp: ICONST
    {
        gen_code(LD_INT, $1);
    }
    | ID
    {
        int address = idcheck($1);

        if(address !=-1)
        {
            gen_code(LD_VAR, address);
        }
    }
    | exp ADDOP exp
    {
        gen_code(ADD, -1);
    }
    | exp LT exp { gen_code(LT_OP, -1); }
    ;

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
