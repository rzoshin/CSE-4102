input = input.txt
output = output.txt

main: lexer.l parser.y
	bison -d parser.y 
	flex lexer.l 
	gcc parser.tab.c lex.yy.c
	./a.out <$(input)> $(output)
	#a <$(input)

assembler:
	C:\masm32\bin\ml /c /coff /Cp prog10.asm
	C:\masm32\bin\link -entry:main /subsystem:console prog10.obj
	prog10
	


