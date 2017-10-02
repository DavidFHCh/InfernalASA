typedef enum _type_list Type_List;
typedef struct _node Node;
typedef struct _list List;

enum _type_list {
  E_CLASS,
  E_FEATURE,
  E_FORMAL,
  E_EXPR,
  E_EXPR_METHOD,
  E_CASE
};

struct _node {
  Node* next;
  void* elem;
  char* rep;
  size_t l_rep;
};

struct _list {
  Node* head;
  Node* last;
  int elements;
  Type_List l_type;
};



int new_list (List**, Type_List);
int add_e (List*, void*);
#define add(L,E) (add_e(L,(void*) E))
