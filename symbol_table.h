#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

// Definir el tamaño máximo de la tabla de símbolos
#define MAX_SYMBOLS 100

// Estructura para representar un símbolo en la tabla
struct symbol {
    char name[50];    // Nombre del símbolo 
    char type[10];    // Tipo de dato 
    char value[50];   // Valor del símbolo 
    int length;       // Longitud 
};

// Declarar la tabla de símbolos como un array de structs
extern struct symbol symbol_table[MAX_SYMBOLS];

// Contador para llevar la cuenta de los símbolos en la tabla
extern int symbol_count;

// Función para agregar un símbolo a la tabla
void add_symbol(char *name, char *type, char *value, int length);

// Función para guardar la tabla de símbolos en un archivo
void save_symbol_table(const char *filename);

#endif  
