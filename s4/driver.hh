#ifndef __DRIVER_H__
#define __DRIVER_H__

#include "parser.hh"
#include <map>
#include <string>
 
#define YY_DECL yy::parser::symbol_type yylex(driver& drv)

class driver{
public:
    int result;
    std::string file;
    bool trace_parcing;
    bool trace_scanning;
    yy::location location;
public:
    driver();
    int parse(const std::string& f);
    void scan_begin();
    void scan_end();
};

YY_DECL;

#endif