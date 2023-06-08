%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern FILE *yyout;
extern int lineno;
extern int yylex();
void return_function(char* line);
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

char* itoa(int value, char* result, int base) {
    // implementación de itoa
}

char* ftoa(double value, char* result, int precision) {
    // implementación de ftoa
}

%}

%union {
    int integer;
    char charval;
    char* stringval;
    double doubleval;
    char* boolean;
}

%token <integer> INTEGER
%token <charval> CHAR
%token <stringval> STRING
%token <doubleval> DOUBLE
%token <boolean> BOOLEAN
%token PRINT
%token IF LT FOR

%type <stringval> value
%type <stringval> line
%type <integer> term
%type <integer> exp
%type <integer> condition

%nonassoc EOL
%%

input:
    %empty
    | input line
    ;
    
line:
        '\n'
    | exp     '\n'   { printf("(%3d) ANS: %.10g\n", $1); };
    | PRINT '(' exp ')' { printf("%d\n", $1); }
    | error { printf("Error\n"); }
    | IF '(' condition ')' '{' line '}' {
        if ($3) {
            $$ = $6;
        } else {
            printf("Conditional error.\n");
        }
    }
    |FOR '(' INTEGER ';' INTEGER ';' INTEGER ')' '{' line '}' {
        for(int i = $3; i < $5; i = i + $7){
            return_function($10);
        }
    }
    ;

////////////////////////////
condition:
    NUM
    INTEGER LT INTEGER {
        $$ = ($1 < $3);
        printf("VALOR BOOL: %d\n", $$);
    }|
    INTEGER GT INTEGER {
        $$ = ($1 > $3);

        printf("VALOR BOOL: %d\n", $$);
    }|
    INTEGER LTE INTEGER {
        $$ = ($1 <= $3);

        printf("VALOR BOOL: %d\n", $$);
    }|
    INTEGER GTE INTEGER {
        $$ = ($1 >= $3);

        printf("VALOR BOOL: %d\n", $$);
    }|
    INTEGER EQUAL INTEGER {
        $$ = ($1 == $3);

        printf("VALOR BOOL: %d\n", $$);
    }|
    ;

    
/////////////////

value:
    INTEGER { char buf[12]; sprintf(buf, "%d", $1); $$ = strdup(buf); }
    | CHAR { char buf[2]; buf[0] = $1; buf[1] = '\0'; $$ = strdup(buf); }
    | STRING { $$ = $1; }
    | DOUBLE { char buf[50]; sprintf(buf, "%.2lf", $1); $$ = strdup(buf); }
    | BOOLEAN { $$ = ($1); }

exp:
    INTEGER
    // | VAR                       { $$ = $1->value.var; }
    // | VAR '=' exp               { $$ = $3; $1->value.var = $3; }
    // | FUN '(' exp ')'           { $$ = $1->value.fun ($3); }
    | '(' exp '+' exp ')'       { $$ = $2 + $4; }
    | '(' exp '-' exp ')'       { $$ = $2 - $4; }
    | '(' exp '*' exp ')'       { $$ = $2 * $4; }
    | '(' exp '/' exp ')'       { $$ = $2 / $4; }
    | '-' exp                   { $$ = -$2; }
    ;

term:
    INTEGER { $$ = $1; }
    ;
///////////////////////////
/////////////////////////////

%%

void return_function(char* line){
    printf("%s\n", line);
}

int main(void) {
    yyparse();
    return 0;
}