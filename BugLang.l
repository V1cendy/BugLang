%{
    #include <stdio.h>
%}
INICIO "start"
FIM "end"

STRING \"[^\"]*\"
NUMBER [0-9]+\.?[0-9]*
VAR []
BOOLEAN true|false

ADI "+"
SUB "-"
MULT "*"
DIV "/"
MOD "%"
ATR "="
PE "("
PD ")"
CE "{"
CD "}"
MAIOR ">"
MENOR "<"
MAI ">="
MEI "<="
IGUAL "=="

PRINT "escreva"
SCAN "leia"
IF "if"
ELSE "else"
WHILE "while"

ID [a-zA-Z_][a-zA-Z0-9_]*
CL "//"+.*
WS [" "\t\n\r]   
%%

{INICIO} {return INICIO;}
{FIM} {return FIM;}
{FS} {return FS;}

{TIPAGEM_INTEIRO} {return TIPAGEM_INTEIRO;}
{TIPAGEM_FLOAT} {return TIPAGEM_FLOAT;}
{TIPAGEM_CHAR} {return TIPAGEM_CHAR;}
{TIPAGEM_STRING} {return TIPAGEM_STRING;}
{TIPAGEM_BOOLEAN} {return TIPAGEM_BOOLEAN;}

{CHAR} {return CHAR;}
{STRING} {
    strcpy(yylval.str, yytext);
    return STRING;}
{INT} {
    yylval.inte = atoi(yytext);
    return INT;}
{FLOAT} {
    yylval.flo = atof(yytext);
    return FLOAT;}
{BOOLEAN} {
    if(strcmp(yytext, "true") == 0)
        yylval.boo = 1;
    else
        yylval.boo = 0;
    return BOOLEAN;}
{ADI} {return ADI;}
{SUB} {return SUB;}
{MULT} {return MULT;}
{DIV} {return DIV;}
{MOD} {return MOD;}
{ATR} {return ATR;}
{PRINT} {return PRINT;}
{SCAN} {return SCAN;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{PE} {return PE;}
{PD} {return PD;}
{CE} {return CE;}
{CD} {return CD;}
{MAIOR} {return MAIOR;}
{MENOR} {return MENOR;}
{MAI} {return MAI;}
{MEI} {return MEI;}
{IGUAL} {return IGUAL;}
{ID} {
    strcpy(yylval.str, yytext);
    return ID;}
%%