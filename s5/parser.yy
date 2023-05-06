%skeleton "lalr1.cc"
%require "3.7.5"
%header

%define api.token.raw

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires{
    #include <string>
    #include<cmath>
    class driver;
}

%param { driver& drv}

%locations

%define parse.trace
%define parse.error detailed
%define parse.lac full

%code{
    #include "driver.hh"
}

%define api.token.prefix {TOK_}
%token
    ASSIGN "="
    MINUS "-"
    PLUS "+"
    STAR "*"
    SLASH "/"
    POWER "^"
    LPAREN "("
    RPAREN ")"
    ;

%token <std::string> IDENTIFIER "identifier"
%token <int> NUMBER "number"
%nterm <int> exp

%printer { yyo << $$; } <*>;