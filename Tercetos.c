#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Tercetos.h"
#include "Lista.h"

Lista lista_tercetos;
int lista_inicializada_tercetos = 0;
int indice;

int compa(const void* e1, const void* e2);

int agregarTerceto(char *operando , char *operadorIzq, char *operadorDer) 
{    
    if (!lista_inicializada_tercetos) 
    {
        crearLista(&lista_tercetos);
        lista_inicializada_tercetos = 1;
        indice = 0;
    }
    
    if (operando == NULL || operadorIzq == NULL || operadorDer == NULL) 
    {
        printf("ERROR LEXICO: El operando o alguno de los operadores no existe.\n");
        return -1;
    }
    // usamos strncpy para evitar overflow de buffer, y forzamos que el último carácter sea \0 para asegurarnos de que las cadenas están correctamente terminadas.    
    terceto nuevo_terceto;
    indice++;
    
    // Copiar los valores en la estructura
    strncpy(nuevo_terceto.operando, operando, sizeof(nuevo_terceto.operando) - 1);
    nuevo_terceto.operando[sizeof(nuevo_terceto.operando) - 1] = '\0';

    strncpy(nuevo_terceto.operadorIzq, operadorIzq, sizeof(nuevo_terceto.operadorIzq) - 1);
    nuevo_terceto.operadorIzq[sizeof(nuevo_terceto.operadorIzq) - 1] = '\0';

    strncpy(nuevo_terceto.operadorDer, operadorDer, sizeof(nuevo_terceto.operadorDer) - 1);
    nuevo_terceto.operadorDer[sizeof(nuevo_terceto.operadorDer) - 1] = '\0';

    nuevo_terceto.indice = indice;

    // Insertar el nuevo terceto en la lista
    insertarListaAlFinal(&lista_tercetos, &nuevo_terceto, sizeof(nuevo_terceto));

    return indice;
}

void guardarTercetos(const char *filename) {
    
    FILE *file = fopen(filename, "w");

    if (file == NULL) 
    {
        printf("Error al intentar guardar el codigo intermedio %s\n", filename);
        return;
    }

    Nodo* current = lista_tercetos;

    while (current != NULL) {
        terceto* _terceto = (terceto*)current->dato; // Obtener el terceto desde el nodo

        // Escribir los tercetos
        fprintf(file, "[%d] (%s; %s; %s)\n", 
                _terceto->indice, 
                _terceto->operando, 
                _terceto->operadorIzq, 
                _terceto->operadorDer);

        // Avanzar al siguiente nodo
        current = current->sig;
    }

    fclose(file);
    printf("Codigo intermedio guardado en en %s\n", filename);
}