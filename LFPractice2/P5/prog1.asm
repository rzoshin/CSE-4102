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

;while_label 5
WHILE_START_LABEL_5:


;ld_var 0
	mov eax, [ebp-0]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int 70
	mov eax, 70
	mov dword ptr [ebx], eax
	add ebx, 4


;lt 8
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	cmp edx, eax
	jl LS8
	mov dword ptr [ebx], 0
	jmp LE8
	LS8: mov dword ptr [ebx], 1
	LE8: add ebx, 4



;while_start 5
	mov eax, [ebx-4]
	cmp eax, 0
	jle WHILE_END_LABEL_5


;ld_var 1
	mov eax, [ebp-4]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int 0
	mov eax, 0
	mov dword ptr [ebx], eax
	add ebx, 4


;gt 12
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	cmp edx, eax
	jg LS12
	mov dword ptr [ebx], 0
	jmp LE12
	LS12: mov dword ptr [ebx], 1
	LE12: add ebx, 4



;if_start 10
	mov eax, [ebx-4]
	cmp eax, 0
	jle ELSE_START_LABEL_10


;print_int_value 0
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
	push [ebp+24]
	push ebp
	mov eax, [ebp-0]
	INVOKE printf, ADDR output_integer_msg_format, eax
	pop ebp
	pop [ebp+24]
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

;else_start 10
	jmp ELSE_END_LABEL_10
ELSE_START_LABEL_10:


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
	push [ebp+20]
	push [ebp+24]
	push ebp
	mov eax, [ebp-4]
	INVOKE printf, ADDR output_integer_msg_format, eax
	pop ebp
	pop [ebp+24]
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

;else_end 10
ELSE_END_LABEL_10:


;ld_var 0
	mov eax, [ebp-0]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int 2
	mov eax, 2
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


;store 0
	mov eax, [ebx-4]
	mov dword ptr [ebp-0], eax

;while_end 5
	jmp WHILE_START_LABEL_5
WHILE_END_LABEL_5:


;halt -1
	add ebp, 200
	mov esp, ebp
	pop ebp
	ret
main endp
end main
