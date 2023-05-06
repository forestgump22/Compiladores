%{
    #include "calc.tab.h"
    #include <symrec.h>
 
    int yywrap(void) { return 1; }
%}
%option yylineno

NUM           [-+]?([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+)|([0-9]+))([Ee][+\-]?[0-9]+)?
CADENA        \"([^\"]*)\"
CARACTER      \'[^\']\'
MAYOR         📏 
VERDADERO     "true"
FALSO         "false"
LITERAL_FLOAT [-+]?[0-9]+(.[0-9]*)?([eE][-+]?[0-9]+)?
LITERAL_INT   (-?[1-9][0-9]*)|0
VAR_           [a-zA-Z_][a-zA-Z0-9_]*
%%

[ \t]         ;
\n           { return '\n'; }
{NUM}        { yylval.num = atof(yytext); printf("%.10g\n", yylval.num); return NUM; }
{VERDADERO}  { yylval.val = 1; return VERDADERO; }
{FALSO}      { yylval.val = 0; return FALSO; }
{MAYOR}      { return '>';  }
{CADENA}     { yylval.str = strdup(yytext); printf("%s\n", yylval.str); return CADENA; }
print                  { return PRINT; }
if                     { return IF; }
for                    { return FOR; }
{VAR_}        { yylval.smp = putsym(yytext, 0); return VAR; }
.            { return yytext[0]; }
<<EOF>> { return EOF; }

%%


