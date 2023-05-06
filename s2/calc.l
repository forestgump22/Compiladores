%{
    #include "calc.h"
    #include "calc.tab.h"    
%}

NUM ([0-9]+\.[0-9]+|([0-9]+\.)|(\.[0-9]+))

%% 
{NUM}  {yyval = atof(yytext);  return NUM;}


%%