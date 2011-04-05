
extern int debug;
extern void yyerror(char *);

struct var {
	struct var *proximo;
	char *nome;
	int	indice;
} *head;

int varcont = 0;

static int _procura_pelo_nome(struct var *v, char *n) {
	if (v) {
		if (debug)
			printf("Comparando <%s> == <%s>\t[", v->nome, n);
		if (!strcmp(v->nome, n)) {
			if (debug)
				printf("IGUAL]\n");
			return v->indice;
		} else {
			if (debug)
				printf("DIFERENTE]\n");
			return _procura_pelo_nome(v->proximo, n);
		}
	} else {
		if (debug)
			printf("Variavel inexistente\n");
		return -1;
	}
}

static int procura_pelo_nome(char *n) {
	if (debug)
		printf("Procurando pela variavel <%s>\n", n);
	if (n)
		return _procura_pelo_nome(head, n);
	else
		yyerror("\n\tNão era prá ter chegado aqui...\n"
				"\n\tSenta e chora!\n\n");
}

int getvar(char *n) {
	int i;

	if (!varcont) {
		if (debug)
			printf("Alocando primeira variavel:\n");

		struct var *novavar = malloc(sizeof(struct var *));
		if (!novavar)
			yyerror("Out of Memory");

		novavar->nome = strdup(n);
		if (debug)
			printf("\tNome: %s\n", novavar->nome);

		novavar->indice = i = varcont++;
		if (debug)
			printf("\tIndice:%d\n", novavar->indice);

		novavar->proximo = NULL;
		head = novavar;
	} else {
		if ((i = procura_pelo_nome(n)) < 0) {
			if (debug)
				printf("Alocando mais uma variavel:\n");

			struct var *novavar = malloc(sizeof(struct var *));
			if (!novavar)
				yyerror("Out of Memory");

			novavar->nome = strdup(n);
			if (debug)
				printf("\tNome: %s\n", novavar->nome);

			novavar->indice = i = varcont++;
			if (debug)
				printf("\tIndice:%d\n", novavar->indice);

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
