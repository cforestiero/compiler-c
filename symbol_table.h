#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TODO_OK 0
#define ERROR 1

#include "Lista.h" 

// Estructura para representar un símbolo en la tabla

typedef struct {
    char nombre[50];    
    char tipo_de_dato[20];    
    char valor[50];   
    char longitud[10];      
}simbolo;


// Función para agregar un símbolo a la tabla
int agregarSimbolo(char *nombre, char *tipo_de_dato, char *valor, char *longitud);

int validarVariableDeclarada(char* nombre);
char * retornarTipoDeDato(char* nombre);

// Función para guardar la tabla de símbolos en un archivo
void guardarTablaDeSimbolos(const char *filename);

simbolo* buscarSimbolo(char* nombre);
void actulizarTipoDeDato(char* nombre, char* valor, char* tipo_de_dato);
int esEntero(char *valor);
int esFlotante(char *valor);
int esString(char *valor);
int esBinario(char *valor);
int validarVariableDeclarada(char* nombre);

int compararArrojandoError(const void *e1, const void *e2);
int copiarTablaDeSimbolos(Lista* lista_externa);

#endif  
