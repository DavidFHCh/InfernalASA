#include "list.h"

static int new_node (Node** node, void* element) {
  Node* n = (Node*) malloc (sizeof (Node));
  if (n == NULL)
    return 1;
  n->elem = element;
  n->next = NULL;
  n->rep = NULL;
  n->l_rep = 0;
  *node = n;
  return 0;
}

int new_list (List** list, Type_List type) {
  List* l = (List*) malloc (sizeof (List));
  if (l == NULL)
    return 1;
  l->head = l->last = NULL;
  l->elementos = 0;
  l->tipo = type;
  *list = l;
  return 0;
}

int add (List* list, void* element) {
  Node* new;
  if (new_node (&new, element))
    return 1;
  if (list->elements == 0) {
    list->head = list->last = new;
  } else {
    list->last->next = new;
    list->last = new;
  }
  list->elements++;
  return 0;
}
