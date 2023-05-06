#include <iostream>
#include <cmath>
#include "calc.tab.h"

using namespace std;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

int main() {
    yyin = stdin;
    yyparse();
    return 0;
}

void yyerror(const char* mensaje) {
    cerr << "Error: " << mensaje << endl;
}

int yylex() {
    return yylex(); // implementación necesaria
}

int yywrap() {
    return 1;
}
