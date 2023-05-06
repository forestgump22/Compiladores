%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>     

    extern int yylineno;
    int yylex(void);
    void yyerror(char const* s){
        fprintf(stderr, "%s\n", s);
    }
%}
%define api.value.type {double}
%token LETTERS
%token VERDADERO
%token FALSO
%token CADENA
%token CHARACTER
%token LITERAL_FLOAT
%token LITERAL_INT
%token NUM
%nterm exp

%%
input:
    %empty
    | input line
    ;

line:
    '\n'
    | exp '\n' { printf("(%3d) ANS: %.10g\n", yylineno, $$); }
    ;

exp:
    NUM
    | VERDADERO          { $$ = 1; }
    | FALSO              { $$ = 0; }
    | '(' exp '+' exp ')' { $$ = $2 + $4; }
    | '(' exp '-' exp ')' { $$ = $2 - $4; }
    | '(' exp '*' exp ')' { $$ = $2 * $4; }
    | '(' exp '/' exp ')' { $$ = $2 / $4; }
    | '-' exp             { $$ = -$2; }
    ;

%%

int main(void){
    return yyparse();
}