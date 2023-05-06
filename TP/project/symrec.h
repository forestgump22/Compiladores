#ifndef SYMREC_H
#define SYMREC_H

#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

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
    

#endif /* SYMREC_H */
