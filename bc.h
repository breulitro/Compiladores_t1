#ifdef DEBUG
#include "debug.h"
#endif
extern void yyerror(char *);

struct var {
	struct var *proximo;
	char *nome;
	int	indice;
} *head;

int varcont = 0;

static int _procura_pelo_nome(struct var *v, char *n) {
	if (v) {
		if (!strcmp(v->nome, n)) {
			return v->indice;
		} else {
			return _procura_pelo_nome(v->proximo, n);
		}
	} else {
		return -1;
	}
}

static int procura_pelo_nome(char *n) {
	if (n)
		return _procura_pelo_nome(head, n);
	else
		yyerror("\n\tNão era prá ter chegado aqui...\n"
				"\n\tSenta e chora!\n\n");
}

int getvar(char *n) {
	int i;

	if (!varcont) {
		struct var *novavar = malloc(sizeof(struct var *));
		if (!novavar)
			yyerror("Out of Memory");

		novavar->nome = strdup(n);
		novavar->indice = i = varcont++;
		novavar->proximo = NULL;
		head = novavar;
	} else {
		if ((i = procura_pelo_nome(n)) < 0) {
			struct var *novavar = malloc(sizeof(struct var *));
			if (!novavar)
				yyerror("Out of Memory");

			novavar->nome = strdup(n);
			novavar->indice = i = varcont++;
			novavar->proximo = head;
			head = novavar;
		} else {
			return i;
		}
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
