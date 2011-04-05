%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int vars[26];	//FIXME: o lexico suporta alocação dinamica

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

%token NUMERO ID MAIS MENOS VEZES DIVIDIR RECEBE
%token GE LE EQ NE;
%token IF ELSE WHILE FOR
%token BE EE FIM
%%

commands: /* empty */
		| commands command FIM
		;

command :
		operacao				{ printf("%d\n", $1);}
		|ID RECEBE operacao		{ vars[$1] = $3 }
		|aindanaousados
		;

aindanaousados:
		IF		{printf("IGNORED\n");}
		|ELSE	{printf("IGNORED\n");}
		|WHILE	{printf("IGNORED\n");}
		|FOR	{printf("IGNORED\n");}
		;

operacao:
		NUMERO
		|ID
		{
			$$ = vars[$1];
		}
		|operacao MAIS operacao
		{
			$$ = $1 + $2;
		}
		|operacao MENOS operacao
		{
			$$ = $1 - $2;
		}
		|operacao DIVIDIR operacao
		{
			$$ = $1 / $2;
		}
		|operacao VEZES operacao
		{
			$$ = $1 * $2;
		}
		|BE operacao EE
		{
			$$ = $2;
		}
		;
