%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(const char *s) {
    fprintf(stderr, "Ta Bugado: %s\n", s);
}

char tipo_atual[20];

// Estrutura de variável
typedef struct vars {
    char name[50];
    char tipo[20];
    float valor;
    char s_valor[100];
    struct vars *prox;
} VARS;

VARS *listaVars = NULL;

VARS *ins(VARS *l, char n[]) {
    VARS *new = (VARS *)malloc(sizeof(VARS));
    strcpy(new->name, n);
    strcpy(new->tipo, tipo_atual);
    new->prox = l;
    return new;
}

VARS *srch(VARS *l, char n[]) {
    VARS *aux = l;
    while (aux != NULL) {
        if (strcmp(n, aux->name) == 0)
            return aux;
        aux = aux->prox;
    }
    return NULL;
}
%}

%union {
    float flo;
    char str[100];
}

%token INICIO FIM VAR PRINT SCAN IF ELSE WHILE
%token MAIOR MENOR MAI MEI II DIF OR AND
%token <str> ID STRING
%token <flo> NUMBER

%type <flo> expressao

%left '+' '-'
%left '*' '/' '%'
%nonassoc MAIOR MENOR MAI MEI II DIF
%left OR AND

%%

programa:
    INICIO bloco FIM
    ;

bloco:
    | comando bloco
    ;

comando:
      declaracao
    | atribuicao
    | atualizacao
    | leitura
    | escrita
    | condicional
    | repeticao


declaracao:
    VAR ID {
        VARS *v = srch(listaVars, $2);
        if (!v) {
            strcpy(tipo_atual, "indefinido");
            listaVars = ins(listaVars, $2);
        }
    }
    ;


atribuicao:
    ID '=' STRING {
        VARS *v = srch(listaVars, $1);
        if (v) {
            if (strcmp(v->tipo, "indefinido") == 0) {
                strcpy(v->tipo, "string");
            }
            if (strcmp(v->tipo, "string") == 0) {
                strcpy(v->s_valor, $3);
            } else {
                printf("Erro: variável %s não é do tipo string.\n", $1);
            }
        }
    }
    | ID '=' expressao {
        VARS *v = srch(listaVars, $1);
        if (v) {
            if (strcmp(v->tipo, "indefinido") == 0) {
                strcpy(v->tipo, "float");
            }
            if (strcmp(v->tipo, "float") == 0) {
                v->valor = $3;
            } else {
                printf("Erro: variável %s não é do tipo float.\n", $1);
            }
        }
    }
    ;


leitura:
    SCAN '(' ID ')' {
        printf("Lendo valor para: %s\n", $3);
    }
    ;

escrita:
    PRINT '(' ID ')' {
        VARS *v = srch(listaVars, $3);
        if (v) {
            if (strcmp(v->tipo, "float") == 0)
                printf("%.2f\n", v->valor);
            else
                printf("%s\n", v->s_valor);
        }
    }
    | PRINT '(' expressao ')' {
        printf("%.2f\n", $3);
    }
    ;

condicional:
    IF '(' expressao ')' '{' bloco '}'
    | IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'
    ;

repeticao:
    WHILE '(' expressao ')' '{' bloco '}'
    ;

expressao:
      expressao '+' expressao { $$ = $1 + $3; }
    | expressao '-' expressao { $$ = $1 - $3; }
    | expressao '*' expressao { $$ = $1 * $3; }
    | expressao '/' expressao { $$ = $1 / $3; }
    | expressao '%' expressao { $$ = (int)$1 % (int)$3; }
    | expressao MAIOR expressao { $$ = $1 > $3; }
    | expressao MENOR expressao { $$ = $1 < $3; }
    | expressao MAI expressao { $$ = $1 >= $3; }
    | expressao MEI expressao { $$ = $1 <= $3; }
    | expressao II expressao { $$ = $1 == $3; }
    | expressao DIF expressao { $$ = $1 != $3; }
    | expressao AND expressao { $$ = $1 && $3; }
    | expressao OR expressao { $$ = $1 || $3; }
    | NUMBER { $$ = $1; }
    | ID {
        VARS *v = srch(listaVars, $1);
        if (v) $$ = v->valor;
        else $$ = 0;
    }
    | '(' expressao ')' { $$ = $2; }
    ;

    atualizacao:
    ID '+' expressao {
        VARS *v = srch(listaVars, $1);
        if (v && strcmp(v->tipo, "float") == 0) {
            v->valor += $3;
        } else {
            printf("Erro: operação inválida com variável %s.\n", $1);
        }
    }
    ;


%%

#include "lex.yy.c"

int main() {
    yyin = fopen("codigo_teste.bug", "r");
    yyparse();
    fclose(yyin);
    return 0;
}
