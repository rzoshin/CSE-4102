#include "codeGen.h"

void gen_code(enum code_ops op, int arg)  /* Generates code at current location */
{
    code[code_offset].op = op;
    code[code_offset].arg = arg;

    code_offset++;
}

int gen_label()    /* Returns current offset */
{
    return code_offset;
}

int reserve_loc()   /* Reserves a code location */
{
    return code_offset++;
}

void back_patch(int addr, enum code_ops operation, int arg)   /* Generates code at a reserved location */
{
    code[addr].op = operation;
    code[addr].arg = arg;
}

void print_code()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);
    }
}

void vm()
{
    int pc = 0;
    struct instruction ir;
    int ar = 7;
    int top = 0;
    char ch;

    do
    {
        ir = code[pc];
        printf("\n;%s %d\n", op_name[ir.op], ir.arg);
        printf( "PC = %3d IR.arg = %8d AR = %3d Top_position = %3d, Top_value = %8d\n", pc, ir.arg, ar, top, stack[top]);

        switch(ir.op)
        {
            case START:
                            break;

            case HALT:
                            break;

            case STORE:
                            stack[ar+ir.arg] = stack[top-1];
                            top--;
                            break;

            case SCAN_INT_VALUE: 
                            scanf( "%d", &stack[ar+ir.arg]);
                            break;

            case PRINT_INT_VALUE:              
                            printf( "%d\n", stack[ar+ir.arg] );
                            top--;
                            break;

            case LD_VAR: 
                            stack[top] = stack[ar+ir.arg];
                            top++;
                            break;

            case LD_INT:
                            stack[top] = ir.arg;
                            top++;
                            break;

            case ADD:
                            top--;
                            stack[top-1] = stack[top-1] + stack[top];            
                            break;
            case SUB:
                            top--;
                            stack[top-1] = stack[top-1] - stack[top];            
                            break;
            case GT_OP:
                            top--;
                            if(stack[top-1] > stack[top])
                                stack[top-1] = 1;            
                            else
                                stack[top-1] = 0;            
                            break;

            case GTE_OP:
                            top--;
                            if(stack[top-1] >= stack[top])
                                stack[top-1] = 1;            
                            else
                                stack[top-1] = 0;            
                            break;
            case LT_OP:
                            top--;
                            if(stack[top-1] < stack[top])
                                stack[top-1] = 1;            
                            else
                                stack[top-1] = 0;            
                            break;

            case LTE_OP:
                            top--;
                            if(stack[top-1] <= stack[top])
                                stack[top-1] = 1;            
                            else
                                stack[top-1] = 0;            
                            break;
            case JMP_FALSE:
                            top--;
                            if(stack[top]==0)
                                pc = ir.arg - 1; //PC will get incremented by 1 later           
                            break;
            case GOTO:
                            pc = ir.arg - 1; //PC will get incremented by 1 later            
                            break;
            default:
                            break;
        }

        pc = pc + 1;

        int j = 0;
        for(j = 0; j<10; j++)
        {
            printf("\tstack[%d] = %d ", j, stack[j]);
        }
        printf("\n");

    }while(ir.op!=HALT);
}