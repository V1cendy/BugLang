%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(char *s){
    printf("Erro sintático: %s\n", s);
}
%}

%union {
    int inte;
    float flo;
    char str[100];
    char ch;
}

%token INICIO FIM
%token VAR PRINT SCAN IF ELSE WHILE
%token MAIOR MENOR MAI MEI II DIF OR AND
%token <str> STRING ID
%token <flo> NUMBER

%type <flo> expressao

%left '+' '-'
%left '*' '/' '%'
%nonassoc MAIOR MENOR MAI MEI 



%%

programa:
    INICIO bloco FIM
    ;

bloco:
    bloco comando
    |
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
    VAR ID
    ;

atribuicao:
    ID '=' STRING 
    | 
    ID '=' NUMBER
    |
    ID '=' expressao 

    ;

leitura:
    SCAN '(' ID ')' { printf("Lendo valor para: %s\n", $3); }
    ;

escrita:
    PRINT '(' ID ')' 
    |
    PRINT '(' expressao ')' { printf("%.2f\n", $3); }
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
    //| ID {$$ = $1; }
    | '(' expressao ')' { $$ = $2; }
    ;
condicional:
    IF '(' expressao ')' '{' bloco '}'
    | IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}'
    ;

repeticao:
    WHILE '(' expressao ')' '{' bloco '}'
    ;
%%

#include "lex.yy.c"

int main() {
    yyin = fopen("codigo_teste.bug", "r");
    yyparse();
    fclose(yyin);
    return 0;
}