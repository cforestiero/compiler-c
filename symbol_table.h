#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TODO_OK 0
#define ERROR 1

// Estructura para representar un símbolo en la tabla

typedef struct {
    char nombre[50];    
    char tipo_de_dato[20];    
    char valor[50];   
    char longitud[10];       
}simbolo;


// Función para agregar un símbolo a la tabla
int agregarSimbolo(char *nombre, char *tipo_de_dato, char *valor, char *longitud, int es_declaracion);

int validarVariableDeclarada(char* nombre);

// Función para guardar la tabla de símbolos en un archivo
void guardarTablaDeSimbolos(const char *filename);


#endif  
