input = input2.txt
output = output.txt

main: lexer.l parser.y
	bison -d parser.y 
	flex lexer.l 
	gcc parser.tab.c lex.yy.c
	./a.out <$(input)> $(output)