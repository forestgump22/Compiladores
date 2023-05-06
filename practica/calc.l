%{
#include <iostream>
#include <cmath>
#include "calc.tab.h"
using namespace std;
%}

%%
[0-9]+(\.[0-9]+)?    { yylval = atof(yytext); return NUMBER; }
"+"         { return ADD; }
"-"         { return SUB; }
"*"         { return MUL; }
"/"         { return DIV; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t]       { /* ignore whitespace */ }
.           { cerr << "Error: caracter inesperado\n"; exit(EXIT_FAILURE); }
%%

int yywrap() {
    return 1;
}
