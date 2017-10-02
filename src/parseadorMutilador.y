%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "list.h"
%}


%start program
%union {
    char* string_t;
    int integer_t;
    Program* program_t;
    Class* class;
    Feature* feature;
    Formal* form;
    Expr* expr;
    List* list;
}
%token CLASS TYPE ID INHERITS SUPER IF ELSE WHILE SWITCH CASE VALUE BREAK DEFAULT NEW RETURN INTEGER STRING TRUE FALSE NULL
%nonassoc '<' '<=' '=='
%left '+' '-'
%left '*' '/'
%type<string_t> TYPE ID STRING
%type<integer_t> INTEGER
%type<programa_t> program
%type<class> class
%type<feature> feature
%type<form> formal
%type<expr> expr
%type<list> class_list feature_list formal_list expr_list method_list case_list default_list
%%

program :
    class
    {
        Program* p;
        new_program(&p);
        add(p->classes, $1);
        $$ = p;
    }
    | program class
    {
        add($1->classes,$2);
    };

class:
    CLASS TYPE
    {
        Class* c;
        new_class(&c,$2,NULL,$4);
        $$ = c;
    }
    | CLASS TYPE INHERITS TYPE
    {
        Class* c;
        new_class(&c,$2,$4,$6);
        $$ = c;
    };

feature_list :
    %empty
    {
        List* l;
        new_list(&l,E_FEATURE);
        $$ = 1;
    }
    | feature_list feature
    {
        add($1,$2);
    };

feature :
    TYPE ID '(' formal_list ')' '{' expr_list RETURN expr ';' '}'
    {
        Feature* f;
        new_feature(&f,METHOD,$1,$2,$9,$4,$7);
        $$ = f;
    }
    | TYPE ID ';'
    {
        Feature* f;
        new_feature(&f,$1,$2,NULL,NULL,NULL);
    }
    | TYPE ID '=' expr ';'
    {
        Feature* f;
        new_feature(&f,$1,$2,$4,NULL,NULL);
    };

formal_list :
    %empty
    {
        List* l;
        new_list(&l,E_FORMAL);
        $$ = 1;
    }
    | formal_list formal
    {
        add($1,$2);
    }
