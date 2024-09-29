input = input3.txt
output = output.txt

main: lexer.l parser1.y
	bison -d parser1.y 
	flex lexer.l 
	gcc parser1.tab.c lex.yy.c
	./a.out <$(input)> $(output)

assembler:
	wine ml.exe /c /coff prog1.asm && wine link.exe prog1.obj && wine prog1.exe