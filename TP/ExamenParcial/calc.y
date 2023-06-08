%{
    #include <stdio.h>
    #include <stdlib.h>

    void yyerror(const char* error_message) {
        fprintf(stderr, "Error sintáctico: %s\n", error_message);
    }
    void prinText(char* s){
        printf("ANS: %s", s);
    }
%}

%token FROM TO SUBJECT EMAIL WORD
%nterm mail headers sender message
%nonassoc EOL

%%

mail:
    %empty
    | headers  message  sender    {prinText("hello world\n");}
    ;

headers:
    %empty                      
    | header headers
    ;

header:
    FROM  EMAIL    '\n'          { $$ = malloc(strlen($1) + strlen($2) + 1); strcpy($$, $1); strcat($$, $2); }
    | TO  EMAIL       '\n'       { $$ = malloc(strlen($1) + strlen($2) + 1); strcpy($$, $1); strcat($$, $2); }
    | SUBJECT  message
    ;

message:
    %empty
    | '\n' message
    | '.' message
    | ',' message
    | WORD  message         { prinText(strdup($1)); };
    ;

sender:
    %empty
    | "--" '\n' message
    ;

%%

int main(int argc, char** argv) {
    yyparse();
    return 0;
}


