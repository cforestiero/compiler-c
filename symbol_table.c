#include <stdio.h>
#include <string.h>
#include "symbol_table.h"
#include "Lista.h"
#include "ListaImplDinamica.h"

Lista lista_simbolos;
int lista_inicializada = 0;
//int symbol_count = 0;

int compa(const void* e1, const void* e2);

void add_symbol(char *name, char *type, char *value, int length) {

    if (!lista_inicializada) {
        crearLista(&lista_simbolos);
        lista_inicializada = 1;
    }
    
    if (name == NULL || type == NULL) {
        printf("ERROR LEXICO: El nombre, tipo o valor de la variable no existe.\n");
        return;
    }

    //if (symbol_count < MAX_SYMBOLS) {
        // usamos strncpy para evitar overflow de buffer, y forzamos que el último carácter sea \0 para asegurarnos de que las cadenas están correctamente terminadas.
        // Suponiendo que `symbol` es una estructura que tiene campos: name, type, value, length
        // y `sizeof(symbol)` es el tamaño total del dato a insertar.

        // Crear el nuevo símbolo
        symbol new_symbol;
        strncpy(new_symbol.name, name, sizeof(new_symbol.name) - 1);
        new_symbol.name[sizeof(new_symbol.name) - 1] = '\0';

        strncpy(new_symbol.type, type, sizeof(new_symbol.type) - 1);
        new_symbol.type[sizeof(new_symbol.type) - 1] = '\0';

        if (value != NULL) {
            strncpy(new_symbol.value, value, sizeof(new_symbol.value) - 1);
            new_symbol.value[sizeof(new_symbol.value) - 1] = '\0';
        } else {
            strcpy(new_symbol.value, "—");
        }

        new_symbol.length = length;

        // Insertar el nuevo símbolo en la lista
        insertarListaOrdSinDupli(&lista_simbolos, &new_symbol, sizeof(new_symbol),compa);

        //strncpy(symbol_table[symbol_count].name, name, sizeof(symbol_table[symbol_count].name) - 1);
        //symbol_table[symbol_count].name[sizeof(symbol_table[symbol_count].name) - 1] = '\0';

        //strncpy(symbol_table[symbol_count].type, type, sizeof(symbol_table[symbol_count].type) - 1);
        //symbol_table[symbol_count].type[sizeof(symbol_table[symbol_count].type) - 1] = '\0';
/*
        if (value != NULL) {
            strncpy(symbol_table[symbol_count].value, value, sizeof(symbol_table[symbol_count].value) - 1);
            symbol_table[symbol_count].value[sizeof(symbol_table[symbol_count].value) - 1] = '\0';
        } else {
            strcpy(symbol_table[symbol_count].value, "—");  // Si no tiene valor, se representa como "—"
        }
*/
        //symbol_table[symbol_count].length = length;  // Guardar la longitud
        //symbol_count++;
    //} else {
       // printf("Error: Tabla de símbolos llena.\n");
    //}
    
}

void save_symbol_table(const char *filename) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error al abrir el archivo %s\n", filename);
        return;
    }

    fprintf(file, "%-40s | %-20s | %-40s | %-10s\n", "NOMBRE", "TIPO DATO", "VALOR", "LONGITUD");
    fprintf(file, "-----------------------------------------------------------------------------------------------------------------------------------\n");
    Nodo* current = lista_simbolos;

    while (current != NULL) {
        symbol* _symbol = (symbol*)current->dato; // Obtener el símbolo desde el nodo

        // Escribir los datos del símbolo en el archivo
        fprintf(file, "%-40s | %-20s | %-40s | %-10d\n", 
                _symbol->name, 
                _symbol->type, 
                _symbol->value, 
                _symbol->length);

        // Avanzar al siguiente nodo
        current = current->sig;
    }
    /*
    for (int i = 0; i < symbol_count; i++) {
        fprintf(file, "%s\t%s\t%s\t%d\n", 
                symbol_table[i].name, 
                symbol_table[i].type, 
                symbol_table[i].value, 
                symbol_table[i].length);
    }*/

    fclose(file);
    printf("Tabla de simbolos guardada en %s\n", filename);

}

int compa(const void *e1, const void *e2) {
    const symbol *s1 = (const symbol *)e1;
    const symbol *s2 = (const symbol *)e2;

    // Comparar por nombre
    int name_comparison = strcmp(s1->name, s2->name);
    if (name_comparison != 0) {
        return name_comparison;
    }

    // Si los nombres son iguales, comparar por tipo
    return strcmp(s1->type, s2->type);
}