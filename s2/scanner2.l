%{
    using namespace std;
    int mylineno = 0;
%}

blank [\t]+
relop (<[=>]?)|(>(=)?)|=

%%
{blank}    /* ignoring white spaces */
{relop}    cout << YYText() << " relop\n";
\n         mylineno++;
.          cout << "punto\n";