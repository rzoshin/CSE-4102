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

%token PRINT ELSE 
%token ADDOP LT GT 
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN

%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> IF
%token<int_val> WHILE

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
    insert($2, UNDEF_TYPE);
    gen_code(STORE, idcheck($2));
};
assignment: ID ASSIGN exp SEMI{
    gen_code(STORE, idcheck($1));
};
while_stat: WHILE {$1 = gen_label(); gen_code(WHILE_LABEL, $1);}LPAREN exp RPAREN{ gen_code(WHILE_START, $1)} tail {gen_code(WHILE_END, $1);};
if_stat: IF {$1 = gen_label();}LPAREN exp RPAREN {gen_code(IF_START, $1);}tail ELSE {gen_code(ELSE_START, $1);} tail {gen_code(ELSE_END, $1);};

tail: LBRACE statements RBRACE;

exp: ID{
    gen_code(LD_VAR, idcheck($1));
}
| ICONST{
    gen_code(LD_INT, $1);
}
| exp ADDOP exp { gen_code(ADD, -1);}
| exp LT exp { gen_code(LT_OP, gen_label());}
| exp GT exp{ gen_code(GT_OP, gen_label());};

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

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}
