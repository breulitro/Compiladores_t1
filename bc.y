%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef DEBUG
#include "debug.h"
#endif

int vars[26];	//FIXME: o lexico suporta alocação dinamica

extern int yylineno;
void var_cleanup();

void yyerror(const char *str) {
	var_cleanup();
	fprintf(stderr, "error: %s at line %d.\n", str, yylineno);
}

int yywrap()
{
	//FIXME: as vezes ele se perde e nao le o Ctrl+D
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
	var_cleanup();
	printf("Processed %d lines\n", yylineno);
}
%}
%token FOR WHILE IF ELSE
%token ID NUMBER
%token DEFINE LID

%token AUTO RETURN SQRT BREAK IBASE OBASE STRING INCR_OP FIM
%%
comandos
	:
	|comandos bloco_de_comando FIM
	;
bloco_de_comando
	:
	|expression					{printf("%d\n", $1);}
	|loop						{printf("_LOOP ");}
	|conditional_statement		{printf("_CONDITIONAL_STATEMENT ");}
	|decl_func					{printf("_DECL_FUNC ");}
	|'{' bloco_de_comando '}'	{printf("_BLOCO_DE_COMANDO_COM_CHAVES ");}
	;
decl_func
	:DEFINE ID '(' params ')' bloco_de_comando
	;
params
	:
	|LID resto_params
	;
resto_params
	:
	|resto_params ',' LID
	;
loop
	:FOR '(' expression ';' expression ';' expression ')' bloco_de_comando
	|WHILE '(' expression ')' bloco_de_comando
	;
conditional_statement
	:IF '(' expression ')' bloco_de_comando conditional_resto
	;
conditional_resto
	:/*Assim fica explicito que está incluído a produção vazia :¬D*/
	|ELSE bloco_de_comando
	;
expression
	:element				{ $$ = $1; }
	/*|expression_list*/
	|ID '=' expression		{vars[$1] = $3; TODO("Declaração implícita");}
	|'(' element ')'
	|'-' element
	|INCR_DECR	{ FIXME("Bug: [\"--\"|\"++\"] ID");}
		ID		/*{ $$ = ($1[0] == '+') ? ++vars[$2] : --vars[$2];}*/
	|ID INCR_DECR	/*{ $$ = ($2[0] == '+') ? ++vars[$1] : --vars[$1]; }*/
	|ID ASSIGN_OP expression	{ FIXME("deve tá quebrada, bem como '++' e '--'"); }
	|element BINFUNC expression {
		YDBG("\e[35mcaiu no [element BINFUNC expression]\n");
		switch ($2) {
		case 0:
			$$ = $1 + $3;
			break;
		case 1:
			$$ = $1 - $3;
			break;
		case 2:
			$$ = $1 * $3;
			break;
		case 3:
			$$ = $1 / $3;
			break;
		case 4:
			$$ = $1 ^ $3;	//TODO: vide todo ver-0.1
			break;
		case 5:
			$$ = $1 % $3;
			break;
		default:
			DBG("Não era prá cair aqui...\n");
			exit(0);
		}

	}
	|expression REL_OP expression
	;
BINFUNC
	:'+'	{ YDBG("[BINFUNC::'+'] "); $$ = 0; }
	|'-'	{ YDBG("[BINFUNC::'-'] "); $$ = 1; }
	|'*'	{ YDBG("[BINFUNC::'*'] "); $$ = 2; }
	|'/'	{ YDBG("[BINFUNC::'/'] "); $$ = 3; }
	|'^'	{ YDBG("[BINFUNC::'^'] "); $$ = 4; }
	|'%'	{ YDBG("[BINFUNC::'%'] "); $$ = 5; }
	;

REL_OP
	:"<="	{ $$ = 0; }
	|">="	{ $$ = 1; }
	|">"	{ $$ = 2; }
	|"<"	{ $$ = 3; }
	|"=="	{ $$ = 4; }
	;

ASSIGN_OP
	:"-="	{ $$ = 0; }
	|"+="	{ $$ = 1; }
	|"*="	{ $$ = 2; }
	|"/="	{ $$ = 3; }
	|"%="	{ $$ = 4; }
	|"^="	{ $$ = 5; }
	|"="	{ $$ = 6; }
	;

INCR_DECR
	:"++"	{ $$ = 0; }
	|"--"	{ $$ = 1; }
	;
element
	:ID		{ $$ = vars[$1]; }
	|NUMBER /* { $$ = $1 } */
	;
