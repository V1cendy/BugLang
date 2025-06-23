%{
    #include <stdio.h>
%}
INICIO "start"
FIM "end"


VAR "var" 
STRING \"[^\"]*\"
NUMBER [0-9]+(\.[0-9]+)?

MAIOR ">"
MENOR "<"
MAI ">="
MEI "<="
II "=="
DIF "!="
OR "||"
AND "&&"

PRINT "print"
SCAN "read"
IF "if"
ELSE "else"
WHILE "while"

ID [a-zA-Z_][a-zA-Z0-9_]*
CL "//".* 
CB "/""*"(.|\n)*"*""/"

%%

{INICIO} {return INICIO;}
{FIM} {return FIM;}

{VAR} {return VAR;}
{STRING} {
    strcpy(yylval.str, yytext);
    return STRING;}
{NUMBER} {
    yylval.flo = atof(yytext);
    return NUMBER;}
{PRINT} {return PRINT;}
{SCAN} {return SCAN;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{MAIOR} {return MAIOR;}
{MENOR} {return MENOR;}
{MAI} {return MAI;}
{MEI} {return MEI;}
{II} {return II;}
{DIF} {return DIF;}
{OR} {return OR;}
{AND} {return AND;}
{ID} {
    strcpy(yylval.str, yytext);
    return ID;}

{CL} {;}
{CB} {;}

"+"|"-"|"/"|"*"|"^"|"%"|"=" {return *yytext;}
[(){};:] {return *yytext;}
[ \t\n\r]*   {;}
%%