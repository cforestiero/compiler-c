#include <stdio.h>
#include <string.h>
#include "simbolo_table.h"
#include "Lista.h"


Lista lista_simbolos;
int lista_inicializada = 0;

int compa(const void* e1, const void* e2);

void agregarSimbolo(char *nombre, char *tipo_de_dato, char *valor, char *longitud) 
{

    if (!lista_inicializada) 
    {
        crearLista(&lista_simbolos);
        lista_inicializada = 1;
    }
    
    if (nombre == NULL || tipo_de_dato == NULL || valor == NULL || longitud == NULL) 
    {
        printf("ERROR LEXICO: El nombre, tipo de dato, valor o longitud del simbolo no existe.\n");
        return;
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
    
}

void guardarTablaDeSimbolos(const char *filename) {
    FILE *file = fopen(filenombre, "w");

    if (file == NULL) 
    {
        printf("Error al intentar guardar la tabla de simbolos en %s\n", filename);
        return;
    }

    fprintf(file, "%-40s | %-20s | %-40s | %-10s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");
    fprintf(file, "-----------------------------------------------------------------------------------------------------------------------------------\n");
    Nodo* current = lista_simbolos;

    while (current != NULL) {
        simbolo* _simbolo = (simbolo*)current->dato; // Obtener el símbolo desde el nodo

        // Escribir los datos del símbolo en el archivo
        fprintf(file, "%-40s | %-20s | %-40s | %-10d\n", 
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