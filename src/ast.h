typedef struct _program Program;
typedef struct _class Class;
typedef struct _feature Feature;
typedef struct _formal Formal;
typedef struct _exp Exp;
typedef enum _type_feature Feature_Type;
typedef enum _expr_type Exp_Type;
typedef enum _ops ops;


struct _program {
    List* classes;
};

struct _class {
    char* name;
    char* super_name;
    List* features;
};

enum _type_feature {
    DECLARATION,
    ASIGNATION,
    METHOD
};

struct _feature {
    Feature_Type type;//used to allow repetition of id's between methods and atributes.
    char* name_type;
    char* id;
    Exp* asign_return;//value asignation or return value.
    List* formals;//params
    List* exprs;//method's body
};

struct _formal {
    char* type;
    char* id;
};

enum _ops {
  ADD,
  SUBST,
  MULT,
  DIV,
  LT,
  LE,
  EQ
};

struct _exp {
  enum {
    INT,
    STR,
    BOOL,
    BIN_OP
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
};

Exp* make_int_exp(int);
Exp* make_bool_exp(int);
Exp* make_str_exp(char*);
Exp* make_op_exp(ops,Exp*,Exp*);
char* op_to_string(ops);

int new_program(Program**);
int new_class(Class**,char*,char*,List*);
int new_feature(Feature**,Feature_Type,char*,char*,Exp*,List*,List*);
int new_formal(Formal**,char*,char*);
