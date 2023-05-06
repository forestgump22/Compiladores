%{
#include <iostream>
%}

%token<numero> NUMERO
%token<entero> ENTERO
%token<flotante> FLOTANTE
%token<cadena> CADENA
%token<identificador> IDENTIFICADOR

%%

programa:
    funciones bloque_sentencias { std::cout << "Programa compilado correctamente" << std::endl; }
;

funciones:
    | funciones funcion
;

funcion:
    tipo_dato IDENTIFICADOR '(' parametros ')' bloque_sentencias
;

tipo_dato:
      ENTERO
    | FLOTANTE
    | CADENA
;

parametros:
    | lista_parametros
;

lista_parametros:
      parametro
    | lista_parametros ',' parametro
;

parametro:
    tipo_dato IDENTIFICADOR
;

bloque_sentencias:
      '{' '}' 
    | '{' lista_sentencias '}'
;

lista_sentencias:
      sentencia
    | lista_sentencias sentencia
;

sentencia:
      asignacion ';'
    | declaracion ';'
    | sentencia_control
    | expresion ';'
;

asignacion:
    IDENTIFICADOR '=' expresion
;

declaracion:
    tipo_dato IDENTIFICADOR
;

sentencia_control:
      sentencia_if
    | sentencia_while
    | sentencia_for
;

sentencia_if:
    IF '(' expresion ')' bloque_sentencias
;

sentencia_while:
    WHILE '(' expresion ')' bloque_sentencias
;

sentencia_for:
    FOR '(' asignacion ';' expresion ';' asignacion ')' bloque_sentencias
;

expresion:
      NUMERO
    | IDENTIFICADOR
    | expresion '+' expresion
    | expresion '-' expresion
    | expresion '*' expresion
    | expresion '/' expresion
;

NUMERO: /[0-9]+/
ENTERO: /🔢/
FLOTANTE: /🔢*\.\d+/
CADENA: /🔡+/
IDENTIFICADOR: /🔠+/

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char* s) {
    std::cerr << s << std::endl;
}
%