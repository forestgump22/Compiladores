%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    const int size =  10;
    struct hashtable {
      int size;
      struct node **table;
    };

    struct node {
      char *key;
      void *value;
      struct node *next;
    };

    void hashtable_free(struct hashtable *ht) {
      for (int i = 0; i < ht->size; i++) {
        struct node *node = ht->table[i];
        while (node != NULL) {
          struct node *next = node->next;
          free(node->key);
          free(node->value);
          free(node);
          node = next;
        }
      }
      free(ht->table);
      free(ht);
    }

    int hashtable_get(struct hashtable *ht, char *key) {
      int hash = 5381;
      for (int i = 0; key[i] != '\0'; i++) {
        hash = (hash * 31) + key[i];
      }
      hash = hash % ht->size;
      struct node *node = ht->table[hash];
      while (node != NULL && strcmp(node->key, key) != 0) {
        node = node->next;
      }
      if (node == NULL) {
        return -1;
      } else {
        return node->value;
      }
    }

    void hashtable_put(struct hashtable *ht, char *key, void *value) {
      int hash = 5381;
      for (int i = 0; key[i] != '\0'; i++) {
        hash = (hash * 31) + key[i];
      }
      hash = hash % ht->size;
      struct node *node = ht->table[hash];
      while (node != NULL && strcmp(node->key, key) != 0) {
        node = node->next;
      }
      if (node == NULL) {
        node = malloc(sizeof(struct node));
        node->key = strdup(key);
        node->value = value;
        node->next = ht->table[hash];
        ht->table[hash] = node;
      } else {
        node->value = value;
      }
    }

    void hashtable_remove(struct hashtable *ht, char *key) {
      int hash = 5381;
      for (int i = 0; key[i] != '\0'; i++) {
        hash = (hash * 31) + key[i];
      }
      hash = hash % ht->size;
      struct node *prev = NULL;
      struct node *node = ht->table[hash];
      while (node != NULL && strcmp(node->key, key) != 0) {
        prev = node;
        node = node->next;
      }
      if (node == NULL) {
        return;
      }
      if (prev == NULL) {
        ht->table[hash] = node->next;
      } else {
        prev->next = node->next;
      }
      free(node->key);
      free(node->value);
      free(node);
    }

    struct hashtable *create_hashtable(int size) {
      struct hashtable *ht = malloc(sizeof(struct hashtable));
      ht->size = size;
      ht->table = malloc(sizeof(struct node *) * size);
      for (int i = 0; i < size; i++) {
        ht->table[i] = NULL;
      }
      return ht;
    }

    struct hashtable *ht;
    int yylex(void);
    void yyerror(char const* s){
        fprintf(stderr, "%s\n", s);
    }
    
    void prinText(char* s){
        printf("ANS: %s\n", s);
    }
%}

%union {
  int num;
  char* str;
  double decim;
  struct node* node;
}

%token <num> INT
%token <decim> DOUBLE
%token <str> ID
%token <str> PRINT

%type <node> var_decl
%type <num> expr
%type program

%%

program:
    %empty
    | expr program { printf("The result is %d\n", $1); }
    ;

expr: 
    INT
    | ID               { $$ = hashtable_get(ht, strdup($1)); }
    | PRINT '(' ID ')' { printf("the variable %s: %d: ", $3 ,hashtable_get(ht, strdup($3))); }
    | ID '=' expr ';'  { 
        hashtable_put(ht, strdup($1), $3);
    }
    | expr '+' expr { $$ = $1 + $3; }
    ;

%%

int main(void){
    ht = create_hashtable(size);
    int result = yyparse();
    hashtable_free(ht);
    return result;
}