%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "list.h"

void yyerror (char*);

char* ast;

int empty;

int errors = 0;

Program* program;
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
%token CLASS TYPE ID INHERITS SUPER IF ELSE WHILE SWITCH CASE VALUE BREAK DEFAULT NEW RETURN INTEGER STRING TRUE_Y FALSE_Y NULL_Y
%nonassoc '<' EQ LE
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
    | formal
    {
        empty = 0;
        List* l;
        new_list(&l,E_FORMAL);
        add(l,$1);
        $$ = 1;
    }
    | formal_list ',' formal
    {
        if(!empty){
            add($1,$3);
        } else {
            yyerror("The parameter has no value.");
        }
    };

expr_list :
    %empty
    {
        List* l;
        new_list(&l,E_EXPR);
        $$ = 1;
    }
    | expr_list expr ';'
    {
        add($1,$2);
    };

formal :
    TYPE ID
    {
        Formal* f;
        new_formal(&f,$1,$2);
        $$ = f;
    }

default_clause :
    %empty
    {
        $$ = NULL;
    }
    | DEFAULT ':' expr_list
    {
        $$ = $3;
    };

/*Faltan las expresiones*/

%%

void yyerror(char* error) {
    errores++;
    fprintf(stderr, " SYNTAX ERROR AT %d: '%s'\n\t%s\n");
    return 1;
}

int main (int argc, char* argv[]){
    if (argc < 3) {
        printf("If you don't know how to use this, read the README.");
        return 1;
    }
    yyin = fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    if(errores) {
        printf("The program contains %d errors. PLEASE correct them.");
    } else {
        size_t len = generate_tree(&ast,program);
        yyout = fopen (argv[2],"w");
        fwrite(ast,sizeof(char),len,yyout);
        fclose(yyout);
    }
    return 0;
}
