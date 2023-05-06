%{
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <cstring>
#include <string>
#include "driver.hh"
#include "parser.hh"
%}

%option noyywrap nounput noinput batch debug

%{
yy:parser::symbol_type
make_NUM(const std::string* s, const yy:parser::location_type& loc);

%}

NUM ([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+)|([0-9]+))([Ee][+\-]?[0-9]+)?

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
    yy::location& loc = drv.location;
    loc.step();
%}

[ \t]   { loc.step(); }
\n      { loc.lines(yyleng); loc.step(); return '\n'; } 
{NUM}   { return make_NUM(yytext, loc); }
.       { return yytext[0]; };
<<EOF>> { return EOF; }

%%