#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct hashtable {
  int size;
  struct node **table;
};

struct node {
  char *key;
  int value;
  struct node *next;
};

struct hashtable *hashtable_new(int size) {
  struct hashtable *ht = malloc(sizeof(struct hashtable));
  ht->size = size;
  ht->table = malloc(sizeof(struct node *) * size);
  for (int i = 0; i < size; i++) {
    ht->table[i] = NULL;
  }
  return ht;
}

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

void hashtable_put(struct hashtable *ht, char *key, int value) {
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

