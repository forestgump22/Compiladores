%skeleton "lalr1.cc"
%require "3.7.5"

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires{
    #include <string>
    #include <cmath>
    class driver;
}

%param { driver& drv}

%locations
/* %define parce.trace */
%define parse.error detailed
%define parse.lac full
%code{
    #include "driver.hh"
}

%define api.token.prefix {TOK_}
%token  <double> NUM "number"
%nterm  <double> exp
%printer { yyo << $$; } <*>;

%%

%start input;
input:
    %empty
    | input line
    ;

line:
      '\n'      { }
    | exp '\n' { std::cout << "ANS: "<< $1 << std::endl; }
    ;
 
exp:
     NUM
    | exp exp '+' { $$ = $1 + $2; }
    | exp exp '-' { $$ = $1 - $2; }
    | exp exp '*' { $$ = $1 * $2; }
    | exp exp '/' { $$ = $1 / $2; }
    | exp exp '^' { $$ = pow($1, $2); }
    | exp 'n'     { $$ = -$1; }
    ;
%%

void yy::parser::error(const location_type& l, const std::string& m){
    std::cerr << l << ": " << m << std::endl; 
}