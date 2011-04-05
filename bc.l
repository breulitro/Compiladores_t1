%{
#include <stdio.h>
#include "bc.tab.h"
#define debug 1 //TODO: Melhorar a forma de debug
void yyerror(char *);

struct var {
	struct var *proximo;
	char *nome;
	int	indice;
} *head;

int varcont = 0;
int getvar();
void var_cleanup();
%}

/* %option yylineno */

%%
if						return IF;
else					return ELSE;
while					return WHILE;
for						return FOR;

[0-9]+					yylval = atoi(yytext); return NUMERO;
quit					exit(0);
[a-zA-Z][a-zA-Z0-9]*	yylval = getvar(yytext);return ID;

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
.						{	printf("error: unknown token \"%s\" at line %d.\n", yytext, yylineno);
							exit(-3);
						}
%%
int _procura_pelo_nome(struct var *v, char *n) {
	if (v) {
		if (debug) printf("Comparando <%s> == <%s>\t[", v->nome, n);
		if (!strcmp(v->nome, n)) {
			if (debug) printf("IGUAL]\n");
			return v->indice;
		} else {
			if (debug) printf("DIFERENTE]\n");
			return _procura_pelo_nome(v->proximo, n);
		}
	} else {
		if (debug) printf("Variavel inexistente\n");
		return -1;
	}
}

int procura_pelo_nome(char *n) {
	if (debug) printf("Procurando pela variavel <%s>\n", n);
	if (n)
		return _procura_pelo_nome(head, n);
	else
		yyerror("\n\tNão era prá ter chegado aqui...\n"
				"\n\tSenta e chora!\n\n");
}

int getvar(char *n) {
	int i;
	if (!varcont) {
		if(debug) printf("Alocando primeira variavel:\n");
		struct var *novavar = malloc(sizeof(struct var *));
		if (!novavar)
			yyerror("Out of Memory");
		novavar->nome = strdup(n);
		if (debug) printf("\tNome: %s\n", novavar->nome);
		novavar->indice = i = varcont++;
		if (debug) printf("\tIndice:%d\n", novavar->indice);
		novavar->proximo = NULL;
		head = novavar;
	} else {
		if ((i = procura_pelo_nome(n)) < 0) {
			if(debug) printf("Alocando mais uma variavel:\n");
			struct var *novavar = malloc(sizeof(struct var *));
			if (!novavar)
				yyerror("Out of Memory");
			novavar->nome = strdup(n);
			if (debug) printf("\tNome: %s\n", novavar->nome);
			novavar->indice = i = varcont++;
			if (debug) printf("\tIndice:%d\n", novavar->indice);
			novavar->proximo = head;
			head = novavar;
		} else return i;
	}
	return i;

}

void var_cleanup() {
	struct var *aux = head;
	while (head) {
		free(head->nome);
		free(head);
		head = aux;
	}
	printf("Cleaned\n");
}
