%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
    int offset;
%}

%union
{
    char str_val[100];
    int int_val;
	struct lbs *lbls;
}

%token PRINT ELSE 
%token ADDOP LT GT 
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN

%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<lbls> IF
%token<lbls> WHILE

%left LT GT
%left ADDOP 

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;
statements: statements statement | ;
statement: declaration | assignment | print_stat | while_stat | if_stat;
declaration: INT ID ASSIGN exp SEMI
{
    insert($2, $1);
    gen_code(STORE, idcheck($2));
};
assignment: ID ASSIGN exp SEMI{
    gen_code(STORE, idcheck($1));
};
while_stat: WHILE {$1 = ( struct lbs*) newlblrec();$1 -> for_goto = gen_label();}LPAREN exp RPAREN {$1 -> for_jmp_false = reserve_loc();}tail { gen_code(GOTO, $1-> for_goto); back_patch($1 -> for_jmp_false, JMP_FALSE, gen_label());};;
if_stat: IF LPAREN exp RPAREN 
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
            };

tail: LBRACE statements RBRACE;

exp: ID{
    gen_code(LD_VAR, idcheck($1));
}
| ICONST{
    gen_code(LD_INT, $1);
}
| exp ADDOP exp { gen_code(ADD, -1);}
| exp LT exp { gen_code(LT_OP, -1);}
| exp GT exp{ gen_code(GT_OP, -1);};

print_stat: PRINT LPAREN ID RPAREN SEMI{
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

    printf("============= RUN CODE IN VIRTUAL MACHINE ===============\n");
    vm();

	return 0;
}
