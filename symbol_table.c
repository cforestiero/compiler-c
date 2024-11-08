#include <stdio.h>
#include <string.h>
#include "symbol_table.h"
#include "Lista.h"

Lista lista_simbolos;
int lista_inicializada = 0;

int compa(const void* e1, const void* e2);

int validarVariableDeclarada(char* nombre) {
    Nodo* current = lista_simbolos;
        while (current != NULL) 
        {
            simbolo* existing_symbol = (simbolo*)current->dato;
            if (strcmp(existing_symbol->nombre, nombre) == 0) 
            {
                return TODO_OK;
            }
            current = current->sig;
        }

    printf("Error: La variable '%s' no ha sido declarada antes de la asignacion.\n", nombre);
    return ERROR;
}

char* retornarTipoDeDato(char* nombre) {
    Nodo* current = lista_simbolos;
        while (current != NULL) 
        {
            simbolo* existing_symbol = (simbolo*)current->dato;
            if (strcmp(existing_symbol->nombre, nombre) == 0) 
            {
                return existing_symbol->tipo_de_dato;
            }
            current = current->sig;
        }

    printf("Error: La variable '%s' no existe\n", nombre);
    return NULL;
}

int agregarSimbolo(char *nombre, char *tipo_de_dato, char *valor, char *longitud) 
{

    if (!lista_inicializada) 
    {
        crearLista(&lista_simbolos);
        lista_inicializada = 1;
    }
    
    if (nombre == NULL || tipo_de_dato == NULL || valor == NULL || longitud == NULL) 
    {
        printf("ERROR LEXICO: El nombre, tipo de dato, valor o longitud del simbolo no existe.\n");
        return  ERROR;
    }

    // usamos strncpy para evitar overflow de buffer, y forzamos que el último carácter sea \0 para asegurarnos de que las cadenas están correctamente terminadas.    
    simbolo nuevo_simbolo;

    strncpy(nuevo_simbolo.nombre, nombre, sizeof(nuevo_simbolo.nombre) - 1);
    nuevo_simbolo.nombre[sizeof(nuevo_simbolo.nombre) - 1] = '\0';

    strncpy(nuevo_simbolo.tipo_de_dato, tipo_de_dato, sizeof(nuevo_simbolo.tipo_de_dato) - 1);
    nuevo_simbolo.tipo_de_dato[sizeof(nuevo_simbolo.tipo_de_dato) - 1] = '\0';

    strncpy(nuevo_simbolo.valor, valor, sizeof(nuevo_simbolo.valor) - 1);
    nuevo_simbolo.valor[sizeof(nuevo_simbolo.valor) - 1] = '\0';
    
    strncpy(nuevo_simbolo.longitud, longitud, sizeof(nuevo_simbolo.longitud) - 1);
    nuevo_simbolo.longitud[sizeof(nuevo_simbolo.longitud) - 1] = '\0'; 
    
    // Insertar el nuevo símbolo en la lista
    insertarListaOrdSinDupli(&lista_simbolos, &nuevo_simbolo, sizeof(nuevo_simbolo),compa); 

    return TODO_OK;
}

void guardarTablaDeSimbolos(const char *filename) {
    FILE *file = fopen(filename, "w");

    if (file == NULL) 
    {
        printf("Error al intentar guardar la tabla de simbolos en %s\n", filename);
        return;
    }

    fprintf(file, "%-50s | %-25s | %-45s | %-10s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");
    fprintf(file, "--------------------------------------------------------------------------------------------------------------------------------------------\n");
    Nodo* current = lista_simbolos;

    while (current != NULL) {
        simbolo* _simbolo = (simbolo*)current->dato; // Obtener el símbolo desde el nodo

        // Escribir los datos del símbolo en el archivo
        fprintf(file, "%-50s | %-25s | %-45s | %-10s\n", 
                _simbolo->nombre, 
                _simbolo->tipo_de_dato, 
                _simbolo->valor, 
                _simbolo->longitud);

        // Avanzar al siguiente nodo
        current = current->sig;
    }

    fclose(file);
    printf("Tabla de simbolos guardada en %s\n", filename);
}

int compa(const void *e1, const void *e2) {
    const simbolo *s1 = (const simbolo *)e1;
    const simbolo *s2 = (const simbolo *)e2;

    // Comparar por nombre
    int nombre_comparison = strcmp(s1->nombre, s2->nombre);
    if (nombre_comparison != 0) {
        return nombre_comparison;
    }

    // Si los nombres son iguales, comparar por tipo
    return strcmp(s1->tipo_de_dato, s2->tipo_de_dato);
}


int compararArrojandoError(const void *e1, const void *e2) {
    // Me llegan dos nombres

    const char *s1 = (const char *)e1;
    const char *s2 = (const char *)e2;
    
    int rta = strcmp(s1, s2);

    if (rta == 0) {
        printf("ERROR SEMANTICO: El simbolo '%s' ya ha sido declarado.\n", s1);
        return ERROR;  // Asegúrate de que ERROR esté definido, por ejemplo, #define ERROR -1
    }

    return rta;
}

int copiarTablaDeSimbolos(Lista* lista_externa) {
    Nodo* current = lista_simbolos;  // Lista es un puntero a Nodo

    while (current != NULL) {
        simbolo* simbolo_actual = (simbolo*)current->dato;  // Obtener el símbolo desde el nodo

        simbolo nuevo_simbolo;
        // Copiar los datos del símbolo a la nueva estructura
        strncpy(nuevo_simbolo.nombre, simbolo_actual->nombre, sizeof(nuevo_simbolo.nombre) - 1);
        nuevo_simbolo.nombre[sizeof(nuevo_simbolo.nombre) - 1] = '\0';

        strncpy(nuevo_simbolo.tipo_de_dato, simbolo_actual->tipo_de_dato, sizeof(nuevo_simbolo.tipo_de_dato) - 1);
        nuevo_simbolo.tipo_de_dato[sizeof(nuevo_simbolo.tipo_de_dato) - 1] = '\0';

        strncpy(nuevo_simbolo.valor, simbolo_actual->valor, sizeof(nuevo_simbolo.valor) - 1);
        nuevo_simbolo.valor[sizeof(nuevo_simbolo.valor) - 1] = '\0';

        strncpy(nuevo_simbolo.longitud, simbolo_actual->longitud, sizeof(nuevo_simbolo.longitud) - 1);
        nuevo_simbolo.longitud[sizeof(nuevo_simbolo.longitud) - 1] = '\0';

        // Llamamos a la función que agrega el símbolo a la lista interna
        insertarListaAlFinal(lista_externa, &nuevo_simbolo, sizeof(nuevo_simbolo)); 

        // Avanzamos al siguiente nodo de la lista externa
        current = current->sig;
    }

    return TODO_OK;
}

