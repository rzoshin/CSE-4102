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

For_stat: FOR {$1 = gen_label(); gen_code(WHILE_LABEL, $1);} Cond {gen_code(WHILE_START, $1);} tail { gen_code(WHILE_END, $1);};

tail: assignment Next_stat;
Cond: ID ASSIGN ICONST TO ICONST{
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
If_stat: IF {$1 = gen_label();} exp { gen_code(IF_START, $1); } THEN Print_stat END IF{ gen_code(ELSE_START, $1); gen_code(ELSE_END, $1); };

Print_stat: PRINT LPAREN ID RPAREN
{
	int address = idcheck($3);
	gen_code(PRINT_INT_VALUE, address)
};
declaration : DIM ID AS type
{
	insert($2,$4);
};

assignment : ID ASSIGN exp SEMI 
{
                int address = idcheck($1);
                if(address != -1)
                {
                    gen_code(STORE, address);
                }
}| ID ASSIGN exp
{
            int address = idcheck($1);
            if(address != -1)
            {
                gen_code(STORE, address);
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
| exp GT exp { gen_code(GT_OP, gen_label()); };

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