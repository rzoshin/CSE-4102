.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 200h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
output_integer_msg_format byte "%d", 0Ah, 0
output_string_msg_format byte "%s", 0Ah, 0
input_integer_format byte "%d",0

number sdword ?

.code

main proc
        push ebp
        mov ebp, esp
        sub ebp, 200
        mov ebx, ebp
        add ebx, 4

;ld_int 50
        mov eax, 50
        mov dword ptr [ebx], eax
        add ebx, 4


;store 0
        mov eax, [ebx-4]
        mov dword ptr [ebp-0], eax

;ld_int 60
        mov eax, 60
        mov dword ptr [ebx], eax
        add ebx, 4


;store 1
        mov eax, [ebx-4]
        mov dword ptr [ebp-4], eax

;ld_var 0
        mov eax, [ebp-0]
        mov dword ptr [ebx], eax
        add ebx, 4


;ld_var 1
        mov eax, [ebp-4]
        mov dword ptr [ebx], eax
        add ebx, 4


;add -1
        sub ebx, 4
        mov eax, [ebx]
        sub ebx, 4
        mov edx, [ebx]
        add eax, edx
        mov dword ptr [ebx], eax
        add ebx, 4


;store 1
        mov eax, [ebx-4]
        mov dword ptr [ebp-4], eax

;ld_var 1
        mov eax, [ebp-4]
        mov dword ptr [ebx], eax
        add ebx, 4


;print_int_value 1
        push eax
        push ebx
        push ecx
        push edx
        push [ebp-4]
        push [ebp-0]
        push [ebp+4]
        push [ebp+8]
        push [ebp+12]
        push [ebp+16]
        push ebp
        mov eax, [ebp-4]
        INVOKE printf, ADDR output_integer_msg_format, eax
        pop ebp
        pop [ebp+16]
        pop [ebp+12]
        pop [ebp+8]
        pop [ebp+4]
        pop [ebp-0]
        pop [ebp-4]
        pop edx
        pop ecx
        pop ebx
        pop eax

;halt -1
        add ebp, 200
        mov esp, ebp
        pop ebp
        ret
main endp
end main