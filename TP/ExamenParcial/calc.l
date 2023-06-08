%{
    #include "calc.tab.h"
    int yywrap(void) { return 1; }
%}

EMAIL       [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
WORD        [a-zA-Z0-9]+(-[a-zA-Z0-9]+)*

%%

[ \t]          ;
{EMAIL}       { yylval = strdup(yytext); return EMAIL; }
From:         { yylval = strdup(yytext); return FROM; }
To:           { yylval = strdup(yytext); return TO; }
Subject:      { yylval = strdup(yytext); return SUBJECT; }
{WORD}        { yylval = strdup(yytext); return WORD; }
.             { return yytext[0]; }
<<EOF>>       { return EOF; }

%%

