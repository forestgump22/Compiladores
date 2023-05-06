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
%token NUM
%token LETTERS
%token FLOTANTE
%token ENTERO
%nterm exp

%%
input:
    %empty
    | input line
    ;

line:
    '\n'
    | exp '\n' { printf("(%3d) ANS: %.10g\n", yylineno, $1);  }
    ;

exp:
    NUM
    | VERDADERO          { $$ = 1; }
    | FALSO              { $$ = 0; }
    | exp exp '+' { $$ = $1 + $2; }
    | exp exp '-' { $$ = $1 - $2; }
    | exp exp '*' { $$ = $1 * $2; }
    | exp exp '/' { $$ = $1 / $2; }
    /* | exp exp '^' { $$ = pow($1, $2); } */
    | exp 'n'     { $$ = -$1; }
    ;
%%

int main(void){
    return yyparse();
}