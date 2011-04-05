%{
#include <stdio.h>
#include "bc.tab.h"
#include "bc.h"
int debug = 1; //TODO: Melhorar a forma de debug

void yyerror(char *);

%}

/* %option yylineno */

%%
if						return IF;
else					return ELSE;
while					return WHILE;
for						return FOR;

[0-9]+					yylval = atoi(yytext); return NUMERO;
quit					exit(0);
[a-zA-Z][a-zA-Z0-9]*	yylval = getvar(yytext); return ID;

"-"						return MENOS;
"+"						return MAIS;
"*"						return VEZES;
"/"						return DIVIDIR;
"="						return RECEBE;

">="					return GE;
"<="					return LE;
"=="					return EQ;
"!="					return NE;

"("						return BE;
")"						return EE;

"\n"					return FIM;//FIXME: Acho que isso vai bixar a regra abaixo

\r?\n					yylineno++;
[ \t]+					/* ignore whitespace */;
.						{
							printf("error: unknown token \"%s\" at line %d.\n", yytext, yylineno);
							exit(-3);
						}
%%
