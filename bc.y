%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


extern int yylineno;

void yyerror(const char *str) {
	fprintf(stderr, "error: %s at line %d.\n", str, yylineno);
}

int yywrap()
{
	return 1;
}

void print_version() {
	printf("\nPUCRS - 2011-01\n"
			"Disciplina: Compiladores\n"
			"Professor: Alexandre Agustini\n");
	printf( "Aluno: %s\n\tMatricula: %s\n"
			"Aluno: %s\n\tMatricula: %s\n",
			"Cristiano Bolla Fernandes",
			"052800042-1",
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

main(int argc, char *argv[]) {
	if (argc == 2)
		if (!strcmp(argv[1], "-v"))
			print_version();
		else
			usage();
	yyparse();
	printf("Processed %d lines\n", yylineno);
}

%}

%token NUMERO IDENTIFICADOR MAIS MENOS VEZES DIVIDIR RECEBE
%token GE LE EQ NE;
%token IF ELSE WHILE FOR
%%

commands: /* empty */
		| commands command
		;

command :
		operacao
		;

operacao:
		NUMERO OP NUMERO
		{
			printf("%d + %d = TODO:¬)\n", $1, $3);
		}
		|MAIS NUMERO
		{
			printf("nova Regraz\n");
		}
		;
OP:
	MAIS
	|MENOS
	|VEZES
	|DIVIDIR
	;
