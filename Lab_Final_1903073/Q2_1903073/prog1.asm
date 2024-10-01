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
ok_msg byte "Ok", 0Ah, 0
not_ok_msg byte "Not Ok", 0Ah, 0

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
        mov edx, [ebx]
        sub ebx, 4
        mov eax, [ebx]
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


;ld_int 20
        mov eax, 20
        mov dword ptr [ebx], eax
        add ebx, 4


;gt 11
        sub ebx, 4
        mov eax, [ebx]
        sub ebx, 4
        mov edx, [ebx]
        cmp edx, eax
        jg LS11
        mov dword ptr [ebx], 0
        jmp LE11
        LS11: mov dword ptr [ebx], 1
        LE11: add ebx, 4



;if_start 9
        mov eax, [ebx-4]
        cmp eax, 0
        jle ELSE_START_LABEL_9


;print_ok_value 0
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
        push [ebp+20]
        push ebp
        mov eax, [ebp-0]
        INVOKE printf, ADDR output_string_msg_format, ADDR ok_msg
        pop ebp
        pop [ebp+20]
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

;else_start 9
        jmp ELSE_END_LABEL_9
ELSE_START_LABEL_9:


;print_not_ok_value 0
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
        push [ebp+20]
        push ebp
        mov eax, [ebp-0]
        INVOKE printf, ADDR output_string_msg_format, ADDR not_ok_msg
        pop ebp
        pop [ebp+20]
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

;else_end 9
ELSE_END_LABEL_9:


;halt -1
        add ebp, 200
        mov esp, ebp
        pop ebp
        ret
main endp
end main