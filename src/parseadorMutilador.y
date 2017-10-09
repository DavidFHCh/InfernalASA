%{
#include <stdio.h>
#include <stdlib.h>
//#include "ast.h"
#include "list.h"

void yyerror (char*);
int empty;
int errors = 0;
extern FILE *yyin;
%}


%start program
%union {
    char* string_t;
    int integer_t;
    char* program_t;
    char* class_t;
    char* feature_t;
    char* formal_t;
    char* expr_t;
    char* list_t;
}
%token CLASS TYPE ID INHERITS SUPER IF ELSE WHILE SWITCH CASE VALUE BREAK DEFAULT NEW RETURN INTEGER STRING TRUE_Y FALSE_Y NULL_Y
%nonassoc '<' EQ LE
%left '+' '-'
%left '*' '/'
%type<string_t> TYPE ID STRING
%type<integer_t> INTEGER
%type<program_t> program
%type<class_t> class
%type<feature_t> feature
%type<formal_t> formal
%type<expr_t> expr default expr_arg_list
%type<list_t> feature_list formal_list expr_list case_list 
%%

program :
    class       { char *s = malloc(1024); 
                  sprintf(s, "%s", $1);
                  printf("%s", s);
                  $$ = s; }
    | program class
                { char *s = malloc(1024);
                  sprintf(s, "%s \n%s", $1, $2);
                  $$ = s; }
    ;

class:
    CLASS TYPE '{' feature_list '}'  
                { char *s = malloc(1024); 
                  sprintf(s, "[CLASS %s \t\n%s]", $2, $4);
                  $$ = s; }
    | CLASS TYPE INHERITS TYPE '{' feature_list '}'
                { $$ = ""; }
    ;

feature_list :
    %empty      { $$ = ""; }
    | feature_list feature
                { char *s = malloc(1024);
                  sprintf(s, "%s \n%s", $1, $2);
                  $$ = s; }
    ;

feature :
    TYPE ID '(' formal_list ')' '{' expr_list RETURN expr ';' '}'
                { char *s = malloc(1024); 
                  sprintf(s, "[METHOD %s %s \n\t%s \n\t%s]", $2, $1, $4, $7);
                  $$ = s; }
    | TYPE ID ';' 
                { char *s = malloc(1024);
                  sprintf(s, "[ATTRIBUTE %s %s]", $2, $1);
                  $$ = s; }
    | TYPE ID '=' expr ';'
                { char *s = malloc(1024);
                  sprintf(s, "[ATTRIBUTE_ASSIGNMENT %s %s %s]", $2, $1, $4);
                  $$ = s; }
    ;

formal_list :
    %empty      { $$ = ""; }
    | formal    { $$ = $1; }
    | formal_list ',' formal
                { char *s = malloc(1024); 
                  sprintf(s, "%s \n%s", $1, $3);
                  $$ = s; }
    ;

expr_list :
    %empty      { $$ = ""; }
    | expr_list expr ';'
                { char *s = malloc(1024);
                  sprintf(s, "%s %s", $1, $2);
                  $$ = s; }
    ;

formal :
    TYPE ID     { char *s = malloc(256); 
                  sprintf(s, "[FORMAL %s %s]", $2, $1);
                  $$ = s; }
    ;

case_list :
    %empty      { $$ = ""; }
    | case_list CASE INTEGER ':' expr_list BREAK ';'
                { char *s = malloc(1024);
                  sprintf(s, "%s \n[CASE %s \n\t%s]", $1, $3, $5);
                  $$ = s; }
    ;

default :
    DEFAULT ':' expr_list
                { char *s = malloc(1024); 
                  sprintf(s, "[DEFAULT \n\t%s]", $3);
                  $$ = s; }
    ;

expr :
    ID '=' expr { char *s = malloc(1024); 
                  sprintf(s, "[ASSIGN \n\t%s \n\t%s]", $1, $3);
                  $$ = s; }
    | expr '.' ID '(' expr_arg_list ')'
                { char *s = malloc(1024); 
                  sprintf(s, "[CALL %s %s \n\t%s]", $1, $3, $5);
                  $$ = s; }
    | expr '.' SUPER '.' ID '(' expr_arg_list ')'
                { char *s = malloc(1024);
                  sprintf(s, "[SUPER_CALL %s %s \n\t%s]", $1, $5, $7); 
                  $$ = s; }
    | ID '(' expr_arg_list ')'
                { char *s = malloc(1024); 
                  sprintf(s, "[CALL %s \n\t%s]", $1, $3); 
                  $$ = s; }
    | IF '(' expr ')' '{' expr_list '}'
                { char *s = malloc(1024); 
                  sprintf(s, "[IF \n\t%s \n\t%s ]", $3, $6);
                  $$ = s; }
    | IF '(' expr ')' '{' expr_list '}' ELSE '{' expr_list '}'
                { char *s = malloc(1024);
                  sprintf(s, "[IF_ELSE \n\t%s \n\t%s \n\t%s]", $3, $6, $10); 
                  $$ = s; }
    | WHILE '(' expr ')' '{' expr_list '}'
                { char *s = malloc(1024);
                  sprintf(s, "[WHILE \n\t%s \n\t%s]", $3, $6); 
                  $$ = s; }
    | SWITCH '(' ID ')' '{' case_list default '}'
                { char *s = malloc(1024);
                  sprintf(s, "[SWITCH %s \n\t%s \n\t%s]", $3, $6, $7);
                  $$ = s; }
    | NEW TYPE
                { char *s = malloc(1024);
                  sprintf(s, "[NEW %s]", $2);
                  $$ = s; }
    | expr '+' expr 
                { char *s = malloc(1024); 
                  sprintf(s, "[ADD \n\t%s \n\t%s]", $1);
                  $$ = s; }
    | expr '-' expr 
                { char *s = malloc(1024); 
                  sprintf(s, "[MIN \n\t%s \n\t%s]", $1);
                  $$ = s; }
    | expr '*' expr
                { char *s = malloc(1024); 
                  sprintf(s, "[MUL \n\t%s \n\t%s]", $1);
                  $$ = s; }
    | expr '/' expr
                { char *s = malloc(1024); 
                  sprintf(s, "[DIV \n\t%s \n\t%s]", $1);
                  $$ = s; }
    | expr '<' expr
                { char *s = malloc(1024); 
                  sprintf(s, "[LT \n\t%s \n\t%s]", $1);
                  $$ = s; }
    | expr LE expr
                { char *s = malloc(1024); 
                  sprintf(s, "[LE \n\t%s \n\t%s]", $1, $3);
                  $$ = s; }
    | expr EQ expr
                { char *s = malloc(1024);
                  sprintf(s, "[EQ \n\t%s \n\t%s]", $1, $3);
                  $$ = s; }
    | '!' expr  { char *s = malloc(512);
                  sprintf(s, "[NEGATION \n\t%s]", $2);
                  $$ = s; }
    | '(' expr ')'
                { $$ = $2; }
    | ID        { char* s = malloc(512);
                  sprintf(s, "[CONSTANT ID %s]", $1);
                  $$ = s; }
    | INTEGER   { char* s = malloc(512);
                  sprintf(s, "[CONSTANT %d]", $1);
                  $$ = s; }
    | STRING    { char* s = malloc(512); 
                  sprintf(s, "[CONSTANT STRING %s]", $1); 
                  $$ = s; }
    | TRUE_Y    { $$ = "[CONSTANT TRUE]"; }
    | FALSE_Y   { $$ = "[CONSTANT FALSE]"; }
    ;

expr_arg_list :
    %empty      { $$ = ""; }
    | expr      { $$ = $1; }
    | expr_arg_list ',' expr
                { char *s = malloc(1024);
                  sprintf(s, "%s \n%s", $3);
                  $$ = $3; }
    ;
%%

void yyerror(char* error) {
    errors++;
    fprintf(stderr, " SYNTAX ERROR AT %d: '%s'\n\t%s\n");
}

int main (int argc, char* argv[]){
    if (argc < 3) {
        printf("If you don't know how to use this, read the README.");
        return 1;
    }
    yyin = fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    if(errors) {
        printf("The program contains %d errors. PLEASE correct them.");
    } else {
    }
    return 0;
}
