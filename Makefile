LEX=flex
YACC=bison
YDBGFLAGS=--verbose
CC=gcc
CLIBS = -lfl
CFLAGS = -DDEBUG
target = bc

all:
	$(LEX) $(target).l
	$(YACC) -d $(target).y
	$(CC) lex.yy.c $(target).tab.c -o $(target) $(CLIBS) $(CFLAGS)

clean:
	rm -f lex.yy.c
	rm $(target).tab.*
	rm $(target)
