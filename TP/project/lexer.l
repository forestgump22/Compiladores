%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
extern FILE *yyin;
extern FILE *yyout;
%}
NUM           [-+]?([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+)|([0-9]+))([Ee][+\-]?[0-9]+)?
STRING        \"[^"]*\"
CARACTER      \'[^\']\'
MAYOR         📏
LLAVE_APER     🔌
LLAVE_CERRA    ⛓ 
VAR_           [a-zA-Z_][a-zA-Z0-9_]*
BOOLEAN        (true|false) 
%%

[ \t]                   ;
\n                     { return '\n'; }
{LLAVE_APER}           { return '{';  }
{LLAVE_CERRA}          { return '}';  }
{BOOLEAN}              { yylval.boolean = strdup(yytext); return BOOLEAN; }
[0-9]+                 { yylval.integer = atoi(yytext); return INTEGER; }
{NUM}                  { yylval.doubleval = atof(yytext); return DOUBLE; }
{MAYOR}                { return '>';  }
{STRING}               { yylval.stringval = strdup(yytext); return STRING; }
'.'                    { yylval.charval = yytext[1]; return CHAR; }
print                  { return PRINT; }
if                     { return IF; }
esmenor                { return LT; }
for                    { return FOR; }
.                      { return yytext[0]; }
<<EOF>>                { return EOF; }

%%

int yywrap() {
    return 1;
}
