%{
#include <iostream>
#include <cmath>
#include <cstdlib>
using namespace std;

#define NUMBER 257
#define ADD 258
#define SUB 259
#define MUL 260
#define DIV 261
#define LPAREN 262
#define RPAREN 263

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* mensaje) {
    cerr << "Error: " << mensaje << endl;
}
%}

%token ADD SUB MUL DIV LPAREN RPAREN
%token <dval> NUMBER


%%

expresion: expresion '+' termino     { $$ = $1 + $3; }
         | expresion '-' termino     { $$ = $1 - $3; }
         | termino                   { $$ = $1; }
         ;

termino: termino '*' factor         { $$ = $1 * $3; }
       | termino '/' factor         { $$ = $1 / $3; }
       | factor                     { $$ = $1; }
       ;

factor: NUMERO                      { $$ = $1; }
      | '(' expresion ')'          { $$ = $2; }
      ;

%%

int main() {
    yyparse();
    return 0;
}


