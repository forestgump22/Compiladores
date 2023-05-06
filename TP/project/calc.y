%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>    
    #include <math.h> 

    typedef double(func_t) (double);
    struct symrec{
        char *name;
        int type;
        union{
            double var;
            func_t *fun;
        }value;
        struct symrec *next;
    };

    typedef struct symrec

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
    int val;
}

%token <val> VERDADERO
%token <val> FALSO

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
    NUM                         { $$ = $1; }
    | VERDADERO                 { $$ = 1; }
    | FALSO                     { $$ = 0; } 
    | '(' exp '+' exp ')'       { $$ = $2 + $4; }
    | '(' exp '-' exp ')'       { $$ = $2 - $4; }
    | '(' exp '*' exp ')'       { $$ = $2 * $4; }
    | '(' exp '/' exp ')'       { $$ = $2 / $4; }
    | '-' exp                   { $$ = -$2; }
    | '(' exp '>' exp ')'       { 
        if($2 > $4) { $$ = 1; }
        else if ($2 == $4) { $$ = 0; }
        else { $$ = -1; }
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
    return yyparse();
}
