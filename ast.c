#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef enum _ops {
  ADD, SUBST, MULT, DIV, LT, LE, EQ
} ops;

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

typedef struct _exp {
  enum {
    INT,  STR,  BOOL, BIN_OP
  } tag;
  
  union {
    int int_expr;
    int bool_expr;
    char* str_expr;
    struct {
      ops op;
      struct _exp* left_expr; 
      struct _exp* right_expr;
    } binop_expr;
  } op;
} exp;

// Constructor de expresiones de tipo INT
exp* make_int_exp(int value) {
  exp* e = (exp*) malloc(sizeof(exp));
  e->tag = INT;
  e->op.int_expr = value;
  return e;
}

// Constructor de expresiones de tipo BOOL
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

exp* make_op_exp(ops op, exp* left, exp* right) {
  exp* e = (exp*) malloc(sizeof(exp));
  e->tag = BIN_OP;
  e->op.binop_expr.op = op;
  e->op.binop_expr.left_expr = left;
  e->op.binop_expr.right_expr = right;
  return e;
}

char* exp_to_string(exp* e) {
  char* str;
  char* left;
  char* right;
  switch(e->tag) {
    case INT:
      str = malloc(128);
      sprintf(str, "<INT, %d>", e->op.int_expr);
      return str;
      break;
    case STR:
      str = malloc(512);
      sprintf(str, "<STR, %s>", e->op.str_expr);
      return str;
      break;
    case BOOL:
      str = malloc(128);
      sprintf(str, "<BOOL, %d>", e->op.bool_expr);
      return str;
      break;
    case BIN_OP: 
      left = exp_to_string(e->op.binop_expr.left_expr);
      right = exp_to_string(e->op.binop_expr.right_expr);
      str = malloc(64 + strlen(left) + strlen(right));
      sprintf(str, "<BIN_OP, %s, %s, %s>", op_to_string(e->op.binop_expr.op), left, right);
      return str;
      break;
  }
  return NULL;
}


int main() {
  exp* e = make_int_exp(69);
  exp* e2 = make_int_exp(420);
  exp* e3 = make_str_exp("holicaceroli");
  exp* e4 = make_op_exp(MULT, e, e2);
  printf("e: %s\n", exp_to_string(e));
  printf("e2: %s\n", exp_to_string(e2));
  printf("e3: %s\n", exp_to_string(e3));
  printf("e4: %s\n", exp_to_string(e4));
  free(e);
  free(e2);
  free(e3);
}
