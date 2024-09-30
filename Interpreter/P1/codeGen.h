enum code_ops 
{
    START, 
    HALT, 
    LD_INT, 
    LD_VAR, 
    STORE, 
    SCAN_INT_VALUE, 
    PRINT_INT_VALUE, 
    ADD,
    SUB,
    GT_OP,
    LT_OP,
    JMP_FALSE,
    GOTO,
};

char *op_name[] = {"start", "halt", "ld_int", "ld_var", "store", "scan_int_value", "print_int_value", "add", "sub", "gt", "lt", "jmp_false", "goto"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct lbs /* Labels for data, if and while */
{
    int for_goto;
    int for_jmp_false;
};

struct lbs * newlblrec() /* Allocate space for the labels */
{
    return (struct lbs *) malloc(sizeof(struct lbs));
}

struct instruction code[999];
extern int address;
int code_offset = 0;

int stack[999];