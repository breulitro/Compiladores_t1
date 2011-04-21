
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "bc.tab.h"
#include "bc.h"
void yyerror(char *);
%}
/* %option outfile="bc.lex.c" header-file="bc.lex.h" */
/* %option yylineno */
%%
"/*"		{ DBG("BEGIN COMMENTS "); comment(); }

quit		{ DBG("Bye! :-)\n"); exit(0); }
if			{ DBG("IF "); return IF; }
else		{ DBG("ELSE "); return ELSE; }
while		{ DBG("WHILE "); return WHILE; }
for			{ DBG("FOR "); return FOR; }
define		{ DBG("DEFINE "); return DEFINE; }
auto		{ DBG("AUTO "); return AUTO; }
return		{ DBG("RETURN "); return RETURN; }

sqrt		{ DBG("SQRT "); return SQRT; }
break		{ DBG("BREAK "); return BREAK; }
ibase		{ DBG("IBASE "); return IBASE; }
obase		{ DBG("OBASE "); return OBASE; }

[0-9]+		{ yylval = atoi(yytext); DBG("NUMBER "); return NUMBER; }
"."			{ DBG(". "); return '.'; }
[a-zA-Z][a-zA-Z0-9]*			{ yylval = getvar(yytext); DBG("ID "); return ID; }
[a-zA-Z_]?\"(\\.|[^\\"])*\"		{ DBG("STRING "); return STRING; }

	/* FIXME: fazer funcionar com yylval */
"--"		{ DBG("-- "); return DECR; }
"++"		{ DBG("++ "); return INCR; }
"<="		{ DBG("<= "); return LE; }
">="		{ DBG(">= "); return GE; }
"=="		{ DBG("== "); return EQ; }
"!="		{ DBG("!= "); return NE; }
"+="		{ DBG("+= "); return PLUSEQUAL; }
"-="		{ DBG("-= "); return MINUSEQUAL; }
"*="		{ DBG("*= "); return ASTERISKEQUAL; }
"/="		{ DBG("/= "); return SLASHEQUAL; }
"^="		{ DBG("^= "); return CHAPEUZINHODOVOVOEQUAL; }
"%="		{ DBG("%= "); return PERCENTEQUAL; }
"-"			{ DBG("- "); return '-'; }
"+"			{ DBG("+ "); return '+'; }
"*"			{ DBG("* "); return '*'; }
"/"			{ DBG("/ "); return '/'; }
"%"			{ DBG("% "); return '%'; }
"^"			{ DBG("^ "); return '^'; }
"="			{ DBG("= "); return '='; }
">"			{ DBG("> "); return '>'; }
"<"			{ DBG("< "); return '<'; }
"("			{ DBG("( "); return '('; }
")"			{ DBG(") "); return ')'; }
"{"			{ DBG("{ "); return '{'; }
"}"			{ DBG("} "); return '}'; }
"["			{ DBG("[ "); return '['; }
"]"			{ DBG("] "); return ']'; }
","			{ DBG(", "); return ','; }
";"			{ DBG("; "); return ';'; }
"\n"		{ yylineno++; DBG("\\n\n"); return FIM;}

[ \t]+		/* ignore whitespace */;

			/* TODO: add suport to va_args debug.h functions */
.			{ printf("error: unknown token \"%s\" at line %d.\n", yytext, yylineno); exit(-3); }
%%

comment() {
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0) {
		unput(c1);
		goto loop;
	}

//	if (c != 0)
//		putchar(c1);
	DBG("END OF COMMENTS ");
}
/*
main(int argc, char *argv[]) {
	if (argc > 1)
		if (!strcmp(argv[1], "-v"))
			print_version();
		else
			usage();

	yylex();
	DBG("Processed %d lines\n", yylineno);
}*/
