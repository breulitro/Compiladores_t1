LEX=flex
YACC=bison
CC=gcc
CLIBS = -lfl
target = bc

all:
	$(LEX) $(target).l
	$(YACC) -d $(target).y
	$(CC) lex.yy.c $(target).tab.c -o $(target) $(CLIBS)

clean:
	rm -f lex.yy.c
	rm $(target).tab.*
	rm $(target)
