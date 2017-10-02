#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "list.h"
#include "ast.h"



char* op_to_string(ops o) {
  switch(o) {
    case ADD:
      return "+"; break;
    case SUBST:
      return "-"; break;
    case MULT:
    case DIV:
      return"/"; break;
    case LT:
      return "<"; break;
    case LE:
      return "<="; break;
    case EQ:
      return "=="; break;
  }
}

// Constructor de Expresiones de tipo INT
Exp* make_int_Exp(int value) {
  Exp* e = (Exp*) malloc(sizeof(Exp));
  e->tag = INT;
  e->op.int_Expr = value;
  return e;
}

// Constructor de Expresiones de tipo BOOL
Exp* make_bool_Exp(int value) {
  Exp* e = (Exp*) malloc(sizeof(Exp));
  e->tag = BOOL;
  e->op.bool_Expr = value;
  return e;
}

// Constructor de Expresiones de tipo STR
Exp* make_str_Exp(char* value) {
  Exp* e = (Exp*) malloc(sizeof(Exp));
  e->tag = STR;
  e->op.str_Expr = value;
  return e;
}

Exp* make_op_Exp(ops op, Exp* left, Exp* right) {
  Exp* e = (Exp*) malloc(sizeof(Exp));
  e->tag = BIN_OP;
  e->op.binop_Expr.op = op;
  e->op.binop_Expr.left_Expr = left;
  e->op.binop_Expr.right_Expr = right;
  return e;
}

char* Exp_to_string(Exp* e) {
  char* str;
  char* left;
  char* right;
  switch(e->tag) {
    case INT:
      str = malloc(128);
      sprintf(str, "<INT, %d>", e->op.int_Expr);
      return str;
      break;
    case STR:
      str = malloc(512);
      sprintf(str, "<STR, %s>", e->op.str_Expr);
      return str;
      break;
    case BOOL:
      str = malloc(128);
      sprintf(str, "<BOOL, %d>", e->op.bool_Expr);
      return str;
      break;
    case BIN_OP:
      left = Exp_to_string(e->op.binop_Expr.left_Expr);
      right = Exp_to_string(e->op.binop_Expr.right_Expr);
      str = malloc(64 + strlen(left) + strlen(right));
      sprintf(str, "<BIN_OP, %s, %s, %s>", op_to_string(e->op.binop_Expr.op), left, right);
      return str;
      break;
  }
  return NULL;
}


int main() {
  Exp* e = make_int_Exp(69);
  Exp* e2 = make_int_Exp(420);
  Exp* e3 = make_str_Exp("holicaceroli");
  Exp* e4 = make_op_Exp(MULT, e, e2);
  printf("e: %s\n", Exp_to_string(e));
  printf("e2: %s\n", Exp_to_string(e2));
  printf("e3: %s\n", Exp_to_string(e3));
  printf("e4: %s\n", Exp_to_string(e4));
  free(e);
  free(e2);
  free(e3);
}
