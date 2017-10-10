looli: lex.yy.c looli.c list.c
	gcc -lfl lex.yy.c looli.c list.c -o looli -g

looli.c looli.h:
	bison -d parseadorMutilador.y -o looli.c

lex.yy.c:
	flex lex.l

clean:
	rm lex.yy.c looli.c looli.h looli 
