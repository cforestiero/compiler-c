#ifndef TERCETOS_H
#define TERCETOS_H

#include "Lista.h" 

// Estructura para representar un símbolo en la tabla

typedef struct {
    int indice;
    char operando[50];    
    char operadorIzq[50];    
    char operadorDer[50];      
}terceto;

typedef struct {
    int indiceBuscado;      // Índice del terceto que quieres actualizar
    char nuevoOperadorIzq[20];   // Nuevo valor para el operador izquierdo
} DatosAccion;

// Función para agregar un símbolo a la tabla
int agregarTerceto(char *operando , char *operadorIzq, char *operadorDer);

// Función para guardar la tabla de símbolos en un archivo
void guardarTercetos(const char *filename);

void actualizarTerceto(int indiceBuscado, const char* nuevoOperadorIzq);
void actualizarTercetoInver(int indiceBuscado);
int copiarListaDeTercetos(Lista* lista_externa);

#endif  
