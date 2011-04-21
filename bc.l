
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "bc.tab.h"
#include "bc.h"

%}
/* %option outfile="bc.lex.c" header-file="bc.lex.h" */
/* %option yylineno */

%%
"/*"		{ printf("BEGIN COMMENTS "); comment(); }

quit		{ printf("Bye! :-)\n"); exit(0); }
if			{ printf("IF "); return IF; }
else		{ printf("ELSE "); return ELSE; }
while		{ printf("WHILE "); return WHILE; }
for			{ printf("FOR "); return FOR; }
define		{ printf("DEFINE "); return DEFINE; }
auto		{ printf("AUTO "); return AUTO; }
return		{ printf("RETURN "); return RETURN; }

sqrt		{ printf("SQRT "); return SQRT; }
break		{ printf("BREAK "); return BREAK; }
ibase		{ printf("IBASE "); return IBASE; }
obase		{ printf("OBASE "); return OBASE; }

[0-9]+		{ yylval = atoi(yytext); printf("NUMBER "); return NUMBER; }
"."			{ printf(". "); return '.'; }
[a-zA-Z][a-zA-Z0-9]*			{ yylval = getvar(yytext); printf("ID "); return ID; }
[a-zA-Z_]?\"(\\.|[^\\"])*\"		{ printf("STRING "); return STRING; }

	/* FIXME: yylval = (char *) tá quebrando o programa */
[\-+*/^%]		{ printf("BINFUNC "); /* yylval = yytext; */FIXME("achar um jeito inteligente de retornar o texto lido"); return yytext[0]; }
[\-+^*%/]?=		{ printf("ASSIGN_OP ");/* yylval = yytext; */ return ASSIGN_OP; }
("<"|">"|">="|"<="|"=="|"!=")	{ printf("REL_OP "); /* yylval = yytext; */ return REL_OP; }
("++"|"--")						{ printf("INCR_DECR ");/* yylval = yytext[0];*/ return INCR_OP; }


"("			{ printf("( "); return '('; }
")"			{ printf(") "); return ')'; }
"{"			{ printf("{ "); return '{'; }
"}"			{ printf("} "); return '}'; }
"["			{ printf("[ "); return '['; }
"]"			{ printf("] "); return ']'; }
","			{ printf(", "); return ','; }
";"			{ printf("; "); return ';'; }
"\n"		{ yylineno++; printf("\\n\n"); return FIM;}

[ \t]+		/* ignore whitespace */;

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
	printf("END OF COMMENTS ");
}
/*
main(int argc, char *argv[]) {
	if (argc > 1)
		if (!strcmp(argv[1], "-v"))
			print_version();
		else
			usage();

	yylex();
	printf("Processed %d lines\n", yylineno);
}
*/
