%{
    #include "calc.tab.h"

    int yywrap(void) { return 1; }
%}
%option yylineno

NUM ([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+)|([0-9]+))([Ee][+\-]?[0-9]+)?

%%

[ \t]    ;
\n      { return '\n'; } 
{NUM}   { yylval = atof(yytext); return NUM; }
.       { return yytext[0]; }
<<EOF>> { return EOF; }

%%