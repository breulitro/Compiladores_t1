%{
#include <stdio.h>
#include "bc.tab.h"
%}
%%
[0-9]+					yylval = atoi(yytext); return NUMERO;
quit					exit(0);
[a-zA-Z][a-zA-Z0-9]*	return IDENTIFICADOR;
\-						return MENOS;
\+						return MAIS;
\*						return VEZES;
\/						return DIVIDIR;
\n					/* ignore end of line */;
[ \t]+				/* ignore whitespace */;
%%

