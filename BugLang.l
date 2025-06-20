%{
    #include <stdio.h>
%}
INICIO "start"
FIM "end"

VAR "var" 
STRING \"[^\"]*\"
NUMBER [0-9]+\.?[0-9]+
BOOLEAN true|false

MAIOR ">"
MENOR "<"
MAI ">="
MEI "<="
IGUAL "=="

PRINT "print"
SCAN "read"
IF "if"
ELSE "else"
WHILE "while"

ID [a-zA-Z_][a-zA-Z0-9_]*
CL "//"+.*

%%

{INICIO} {return INICIO;}
{FIM} {return FIM;}

{STRING} {
    strcpy(yylval.str, yytext);
    return STRING;}
{NUMBER} {
    yylval.flo = atof(yytext);
    return NUMBER;}
{BOOLEAN} {
    if(strcmp(yytext, "true") == 0)
        yylval.boo = 1;
    else
        yylval.boo = 0;
    return BOOLEAN;}

{PRINT} {return PRINT;}
{SCAN} {return SCAN;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{MAIOR} {return MAIOR;}
{MENOR} {return MENOR;}
{MAI} {return MAI;}
{MEI} {return MEI;}
{IGUAL} {return IGUAL;}
{ID} {
    strcpy(yylval.str, yytext);
    return ID;}
[-+()=/*^%{};] {return *yytext;}
[ \t\n\r]*   {;}
%%