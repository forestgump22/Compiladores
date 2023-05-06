%{
    #include "calc.tab.h"
    #include <math.h> 
    int yywrap(void) { return 1; }
%}
%option yylineno

NUM         [-+]?([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+)|([0-9]+))([Ee][+\-]?[0-9]+)?
CADENA      \"([^\"]*)\"
CARACTER    \'[a-zA-Z]\'
MAYOR       📏 
VERDADERO "true"
FALSO "false"
LITERAL_FLOAT [-+]?[0-9]+(.[0-9]*)?([eE][-+]?[0-9]+)?
LITERAL_INT (-?[1-9]{0,4})|0

%%

[ \t]         ;
\n           { return '\n'; }
{NUM}        { yylval.num = atof(yytext); printf("%.10g\n", yylval.num); return NUM; }
{VERDADERO}  { yylval.val = 1; return VERDADERO; }
{FALSO}      { yylval.val = 0; return FALSO; }
{MAYOR}           { return '>';  }
{CADENA}     { yylval.str = strdup(yytext); printf("%s\n", yylval); return CADENA; }
.            { return yytext[0]; }
<<EOF>> { return EOF; }

%%

