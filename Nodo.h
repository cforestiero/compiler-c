#ifndef NODO_H
#define NODO_H

typedef struct sNodo
{
    void* dato;
    size_t tam;
    struct sNodo* sig;
} Nodo;

#endif // NODO_H
