#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "list.h"
#include "ast.h"



// Constructor de expresiones de tipo INT
exp* make_int_exp(int value) {
  exp* e = (exp*) malloc(sizeof(exp));
  e->tag = INT;
  e->op.int_expr = value;
  return e;
}

exp* make_bool_exp(int value) {
  exp* e = (exp*) malloc(sizeof(exp));
  e->tag = BOOL;
  e->op.bool_expr = value;
  return e;
}

// Constructor de expresiones de tipo STR
exp* make_str_exp(char* value) {
  exp* e = (exp*) malloc(sizeof(exp));
  e->tag = STR;
  e->op.str_expr = value;
  return e;
}

//void free_exp(exp* e) {
//  free(e);
//}

int main() {
  exp* e = make_int_exp(69);
  printf("Expresión e con etiqueta %d y valor %d \n", e->tag, e->op.int_expr);
  exp* e2 = make_str_exp("holi");
  printf("Expresión e2 con etiqueta %d y valor %s \n", e2->tag, e2->op.str_expr);
  exp* e3 = make_bool_exp(0);
  printf("Expresion e3 con etiqueta %d y valor %d \n", e3->tag, e3->op.bool_expr);
  free(e);
  free(e2);
  free(e3);
}
