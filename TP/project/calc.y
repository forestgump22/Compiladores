%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>    
    #include <math.h>
    #include <assert.h>
    //int FUN = 1;
    // desde aqui
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

    typedef struct symrec symrec;

    extern symrec *sym_table;

    symrec *putsym (char const *name, int sym_type);
    symrec *getsym (char const *name);

    struct init{
        char const *name;
        func_t *fun;
    };

    struct init const funs[]={
        { "atan", atan },
        { "cos",  cos  },
        { "exp",  exp  },
        { "ln",   log  },
        { "sin",  sin  },
        { "sqrt", sqrt },
        { 0 , 0 },
    };

    symrec *sym_table;
    
    static void init_table(void){
        for (int i = 0; funs[i].name; i++){
            symrec *ptr = putsym (funs[i].name, 1);
            ptr->value.fun = funs[i].fun;
        }
    }
    symrec* putsym (char const *name, int sym_type){
        symrec *res = (symrec *) malloc (sizeof (symrec));
        res->name = strdup(name);
        res->type = sym_type;
        res->value.var = 0;
        res->next = sym_table;
        sym_table = res;
        return res;
    }

    symrec* getsym (char const *name){
        for (symrec *p = sym_table; p; p = p->next){
            if (strcmp(p->name, name) == 0){
                return p;
            }
        }
        return NULL;
    }
    // hasta aqui

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
    symrec* smp;
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
