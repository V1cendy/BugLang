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
    int inte;
    float flo;
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
    | leitura
    | escrita
    | condicional
    | repeticao
    ;

declaracao:
    VAR ID {
        VARS *v = srch(listaVars, $2);
        if (!v) {
            strcpy(tipo_atual, "indefinido");
            listaVars = ins(listaVars, $2);
        }
    };

atribuicao:
    ID '=' STRING {
        VARS *v = srch(listaVars, $1);
        if (v) {
            strcpy(v->s_valor, $3);
            strcpy(v->tipo, "string");
            //printf("atribuiu string\n");
        }
    }
    |ID '=' expressao {
        VARS *v = srch(listaVars, $1);
        if (v) {
            // Para simplificar, sempre define como float
            v->flo = $3;
            v->inte = (int)$3;
            strcpy(v->tipo, floor($3) == $3 ? "int" : "float");
        }
    };


leitura:
    SCAN '(' ID ')' {
        VARS *v = srch(listaVars, $3);
        if (!v) {
            printf("Erro: variável %s não declarada.\n", $3);
        } else {
            char buffer[100];
            scanf(" %99[^\n]", buffer);

            int int_val;
            float float_val;

            // Primeiro tenta int
            if (sscanf(buffer, "%d", &int_val) == 1 && strchr(buffer, '.') == NULL) {
                v->inte = int_val;
                strcpy(v->tipo, "int");
            }
            // Depois tenta float
            else if (sscanf(buffer, "%f", &float_val) == 1) {
                v->flo = float_val;
                strcpy(v->tipo, "float");
            }
            // Senão, assume string
            else {
                snprintf(v->s_valor, sizeof(v->s_valor), "%s", buffer);
                strcpy(v->tipo, "string");
            }
        }
    };

escrita:
    PRINT '(' expressao ')' {
        if (floor($3) == $3)
            printf("%d\n", (int)$3);
        else
            printf("%.2f\n", $3);
    }
    | PRINT '(' ID ')' {
        VARS *v = srch(listaVars, $3);
        if (v) {
            if (strcmp(v->tipo, "int") == 0)
                printf("%d\n", v->inte);
            else if (strcmp(v->tipo, "float") == 0)
                printf("%.2f\n", v->flo);
            else {
                // Remove as aspas da string salva
                char temp[100];
                if (v->s_valor[0] == '"' && v->s_valor[strlen(v->s_valor) - 1] == '"') {
                    strncpy(temp, v->s_valor + 1, strlen(v->s_valor) - 2);
                    temp[strlen(v->s_valor) - 2] = '\0';
                    printf("%s\n", temp);
                } else {
                    printf("Variavel vazia\n");
                }
            }
        }
    }
    | PRINT '(' STRING ')' {
    char temp[100];
    strncpy(temp, $3 + 1, strlen($3) - 2); // remove aspas
    temp[strlen($3) - 2] = '\0';
    printf("%s\n", temp);
    };

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
        if (v) {
            if (strcmp(v->tipo, "int") == 0) $$ = v->inte;
                else if (strcmp(v->tipo, "float") == 0) $$ = v->flo;
                    else $$ = 0;
        }
    }
    | '(' expressao ')' { $$ = $2; }
    ;
%%

#include "lex.yy.c"

int main() {
    yyin = fopen("codigo_teste.bug", "r");
    yyparse();
    fclose(yyin);
    return 0;
}
