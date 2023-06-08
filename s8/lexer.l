%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"
 
    int yywrap(void) { return 1; }
%}
%option yylineno

ID        [a-zA-Z][a-zA-Z0-9]*
INT       [0-9]+
PRINT     print
DOUBLE    [-+]?\d*\.\d+
%%

[ \t\n]     ;

{PRINT}   { yylval.str = strdup(yytext); return PRINT; }
{INT}     { yylval.num = atoi(yytext); return INT; }
{DOUBLE}  { yylval.decim = atof(yytext); return DOUBLE; }
{ID}      { yylval.str = strdup(yytext); return ID; }
.         { return yytext[0]; }
<<EOF>>   { return EOF; }
%%