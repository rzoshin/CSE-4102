input = input.txt


main: lexer.l parser.y
	bison -d parser.y 
	flex lexer.l 
	gcc parser.tab.c lex.yy.c
	./a.out <$(input)

assembler:
	wine ml.exe /c /coff prog1.asm && wine link.exe prog1.obj && wine prog1.exe