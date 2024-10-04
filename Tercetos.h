#ifndef TERCETOS_H
#define TERCETOS_H

// Estructura para representar un símbolo en la tabla

typedef struct {
    int indice;
    char operando[50];    
    char operadorIzq[50];    
    char operadorDer[50];      
}terceto;


// Función para agregar un símbolo a la tabla
int agregarTerceto(char *operando , char *operadorIzq, char *operadorDer);

// Función para guardar la tabla de símbolos en un archivo
void guardarTercetos(const char *filename);

#endif  
