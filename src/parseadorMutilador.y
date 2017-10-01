%{
#include <stdio.h>
#include <stdlib.h>
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
        add_class(p, $1);
        $$ = p;
    }
    |program class
    {
        add_class($1,$2);
    };
