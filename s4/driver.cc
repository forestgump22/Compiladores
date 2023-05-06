#include "driver.hh"

driver::driver():trace_parcing(false), trace_scanning(false){

}

int driver::parse(const std::string& f){
    file = f;
    locations.initialize(&file); 
    scan_begin();
    yy::parser parse(&this);
    parse.set_debug_level(trace_parcing);
    int res = parse();
    scan_end();
    return result;
}