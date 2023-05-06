%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>    
    #include <math.h>
    init_table();
    extern int yylineno;
    int yylex(void);
    void yyerror(char const* s){
        fprintf(stderr, "%s\n", s);
    }
    void prinText(char* s){
        printf("ANS: %s\n", s);
    }
%}

%union {
    double num;
    char* str;
    char ch;
    struct symrec* smp;
    int val;
}

%token <val> VERDADERO
%token <val> FALSO
%token <smp> VAR
%token <smp> FUN

%token <str> CADENA
%token <str> CHARACTER
%token <num> LITERAL_FLOAT
%token <val> LITERAL_INT

%token <num> NUM
%nterm <num> exp
// %nterm <val> expbool
%nterm <str> texto
%nterm line
// %nterm condicional
%nonassoc EOL

%%
input:
    %empty
    | input line
    ;

line:
       '\n'
    | exp     '\n'    { printf("(%3d) ANS: %.10g\n", yylineno, $1); };
    | texto   '\n'    { prinText(strdup($1)); };
    ;

exp:
    NUM
    | VAR                       { $$ = $1->value.var; }
    | VAR '=' exp               { $$ = $3; $1->value.var = $3; }
    | FUN '(' exp ')'           { $$ = $1->value.fun ($3); }
    | VERDADERO                 { $$ = 1; }
    | FALSO                     { $$ = 0; } 
    | '(' exp '+' exp ')'       { $$ = $2 + $4; }
    | '(' exp '-' exp ')'       { $$ = $2 - $4; }
    | '(' exp '*' exp ')'       { $$ = $2 * $4; }
    | '(' exp '/' exp ')'       { $$ = $2 / $4; }
    | '-' exp                   { $$ = -$2; }
    | '(' exp '>' exp ')'       { 
        return $2 > $4;
    }
    ;

// expbool:
//     VERDADERO          { $$ = 1; }
//     | FALSO            { $$ = 0; }  
//     ;

texto:
    CADENA                      { $$ = strdup($1); printf("ANS: %s\n", strdup($1));}
    | '(' texto '+' texto ')'    { $$ = malloc(strlen($2) + strlen($4) + 1); strcpy($$, $2); strcat($$, $4); }
    ;

%%

int main(void){
    symrec* rect;
    init_table();
    return yyparse();
}
