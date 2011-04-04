%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
	return 1;
}

void print_version() {
	printf("\nPUCRS - 2011-01\n"
			"Disciplina: Compiladores\n"
			"Professor: Lulu Santos\n");
	printf( "Aluno: %s\n\tMatricula: %s\n"
			"Aluno: %s\n\tMatricula: %s\n",
			"Cristiano Bolla Fernandes",
			"TODO",
			"Benito O.J.R.L.M.S.",
			"05202815-6");
	printf("\n\e[31mTODO:\e[0m Breve Descrição do trabalho\n");
	exit(-2);
}

void usage() {
	printf("Valid Options\n"
			"-v\tPrints Program Description\n");
	exit(-1);
}

main(int argc, char *argv[])
{
	if (argc == 2)
		if (!strcmp(argv[1], "-v"))
			print_version();
		else
			usage();
	yyparse();
}

%}

%token NUMERO IDENTIFICADOR MAIS MENOS VEZES DIVIDIR
%%

commands: /* empty */
		| commands command
		;

command :
		operacao
		;

operacao:
		NUMERO MAIS NUMERO
		{
			printf("%d + %d = TODO:¬)\n", $1, $3);
		}
		|MAIS NUMERO
		{
			printf("nova Regraz\n");
		}
		;
