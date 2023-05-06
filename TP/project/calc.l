%{
    #include "calc.tab.h"

    int yywrap(void) { return 1; }
%}
%option yylineno

NUM            [-+]?([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+)|([0-9]+))([Ee][+\-]?[0-9]+)?
CADENA         [a-zA-Z_][a-zA-Z0-9_]*
CHARACTER      [a-zA-Z]

VERDADERO      (true)
FALSO          (false)
LITERAL_FLOAT  [-+]?[0-9]+(\.[0-9]*)?([eE][-+]?[0-9]+)?
LITERAL_INT    (-?[1-9]{0,4})|0
%%

[ \t]           ;
\n              { return '\n'; }
{NUM}           { yylval = atof(yytext); return NUM; }
.               { return yytext[0]; }
{VERDADERO}     { yylval = 1; return VERDADERO; }
{FALSO}         { yylval = 0; return FALSO; }
<<EOF>>         { return EOF; }

%%