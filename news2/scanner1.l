%{
//declaraciones
#include <iostream>
using namespace std;
int mylineno = 0;
%}

blank [\t]+
relop (<[=>]?)|(>(=)?)|=
/*relop*/
%% 

{blank}+  {}
{relop}   cout << YYText() <<"relop\n";
\n        mylineno++;
<<EOF>> return EOF;
%%
//funciones auxiliares
int yyFlexLexer::yywrap() { return 1; }

int main(){
    FlexLexer* lexer = new yyFlexLexer();
    while (lexer->yylex()){

    };

    return 0;
}
