#include <stdio.h>
#include <string.h>
#include "symbol_table.h"

struct symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

void add_symbol(char *name, char *type, char *value, int length) {
    if (name == NULL || type == NULL || value == NULL) {
        printf("Error: El nombre, tipo o valor NULL.\n");
        return;
    }

    if (symbol_count < MAX_SYMBOLS) {
        // usamos strncpy para evitar overflow de buffer, y forzamos que el último carácter sea \0 para asegurarnos de que las cadenas están correctamente terminadas.
        strncpy(symbol_table[symbol_count].name, name, sizeof(symbol_table[symbol_count].name) - 1);
        symbol_table[symbol_count].name[sizeof(symbol_table[symbol_count].name) - 1] = '\0';

        strncpy(symbol_table[symbol_count].type, type, sizeof(symbol_table[symbol_count].type) - 1);
        symbol_table[symbol_count].type[sizeof(symbol_table[symbol_count].type) - 1] = '\0';

        if (value != NULL) {
            strncpy(symbol_table[symbol_count].value, value, sizeof(symbol_table[symbol_count].value) - 1);
            symbol_table[symbol_count].value[sizeof(symbol_table[symbol_count].value) - 1] = '\0';
        } else {
            strcpy(symbol_table[symbol_count].value, "—");  // Si no tiene valor, se representa como "—"
        }

        symbol_table[symbol_count].length = length;  // Guardar la longitud
        symbol_count++;
    } else {
        printf("Error: Tabla de símbolos llena.\n");
    }
}

void save_symbol_table(const char *filename) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error al abrir el archivo %s\n", filename);
        return;
    }

    fprintf(file, "NOMBRE\tTIPODATO\tVALOR\tLONGITUD\n");

    for (int i = 0; i < symbol_count; i++) {
        fprintf(file, "%s\t%s\t%s\t%d\n", 
                symbol_table[i].name, 
                symbol_table[i].type, 
                symbol_table[i].value, 
                symbol_table[i].length);
    }

    fclose(file);
    printf("Tabla de símbolos guardada en %s\n", filename);
}
