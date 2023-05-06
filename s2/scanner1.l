%{
using namespace std;
int mylineno = 0;
%}

blank [\t\r]+
relop (<[=>]?)|(>(=)?)|=

%%

{blank}+ {}
"<>"     cout<<"relop NE\n";
"<="     cout<<"relop LE\n";
"<"      cout<<"relop LT\n";
">"      cout<<"relop GE\n";
">="     cout<<"relop GT\n";
"="      cout<<"relop EG\n";
\n       mylineno++;
<<EOF>>  return EOF;

%%
int yyFlexLexer::yywrap() { return 1;}

int main(){
    // yylex();
    FlexLexer* lexer = new yyFlexLexer();
    while (lexer->yylex()!=0)
    ;
    return 0;
}
