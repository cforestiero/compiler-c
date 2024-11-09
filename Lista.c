#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include "Lista.h"

///principales
void crearLista(Lista* pl)
{
    *pl = NULL;
}
void vaciarLista(Lista* pl)
{
    Nodo *nodoDelete;
    while(*pl)
    {
        nodoDelete = *pl;
        *pl = nodoDelete->sig;

        free(nodoDelete->dato);
        free(nodoDelete);
    }
}
///estado
int listaVacia(const Lista* pl)
{
    return !*pl;
}
int listaLlena(const Lista *pl, size_t tam)
{
    Nodo* nodo = (Nodo*)malloc(sizeof(Nodo));
    void* dato = malloc(tam);

    if (!nodo || !dato)
    {
        free(nodo);
        free(dato);
        return SIN_MEMORIA;
    }

    return TODO_OK;
}
int verPrimeroLista(Lista *pl, void *dato, size_t tam)
{
    if(!*pl)
        return 0;

    memcpy(dato, (*pl)->dato, MIN(tam,(*pl)->tam));
    return 1;
}
int verUltimoLista(Lista *pl, void *dato, size_t tam)
{
    if(!*pl)
        return 0;

    while((*pl)->sig)
        pl = &(*pl)->sig;

    memcpy(dato, (*pl)->dato, MIN(tam, (*pl)->tam));
    return 1;
}
///contar
int contarElementos(const Lista *pl)
{
    int contador = 0;

    while(*pl)
    {
        pl = &(*pl)->sig;
        contador++;
    }
    return contador;
}
int contarElementosPorClaveOrd(const Lista *pl, const void* dato, Cmp cmp)
{
    int contador = 0;

    while(*pl && (cmp(dato,(*pl)->dato) != 0))
        pl = &(*pl)->sig;
    while(*pl && (cmp(dato,(*pl)->dato) == 0))
    {
        contador++;
        pl = &(*pl)->sig;
    }
    return contador;
}
int contarElementosPorClaveDesord(const Lista *pl, const void* dato, Cmp cmp)
{
    int contador = 0;

    while(*pl)
    {
        if (cmp(dato,(*pl)->dato))
            contador++;
        pl = &(*pl)->sig;
    }
    return contador;
}

int buscarEnLista(const Lista* pl, const void* dato, Cmp cmp)
{
    // Recorre la lista hasta encontrar el dato o llegar al final
    while (*pl && cmp(dato, (*pl)->dato) > 0)
    {
        pl = &(*pl)->sig;
    }

    // Verifica si el dato encontrado es el mismo que se está buscando
    if (*pl && cmp(dato, (*pl)->dato) == 0)
    {
        return DUPLICADO;  // El dato ya existe en la lista
    }

    return TODO_OK;  // El dato no existe en la lista
}

///insertar
int insertarListaOrdSinDupli(Lista* pl, const void* dato, size_t tam, Cmp cmp)
{
    while(*pl && cmp(dato,(*pl)->dato)>0)
        pl = &(*pl)->sig;

    if(*pl && cmp(dato,(*pl)->dato) == 0)
    {
        return DUPLICADO;
    }
        

    Nodo* nue = (Nodo*)malloc(sizeof(Nodo));
    void* datoN = malloc(tam);

    if (!nue || !datoN)
    {
        free(nue);
        free(datoN);
        return SIN_MEMORIA;
    }

    memcpy(datoN, dato, tam);
    nue->dato = datoN;
    nue->tam = tam;
    nue->sig = *pl;
    *pl = nue;

    return TODO_OK;
}
int insertarOActualizarListaOrd(Lista* pl, const void* dato, size_t tam, Cmp cmp, Actualizar actualizar)
{
    while(*pl && cmp(dato,(*pl)->dato)>0)
        pl = &(*pl)->sig;

    if(*pl && cmp(dato,(*pl)->dato) == 0)
    {
        actualizar((*pl)->dato,dato);
        return TODO_OK;
    }

    Nodo* nue = (Nodo*)malloc(sizeof(Nodo));
    void* datoN = malloc(tam);

    if (!nue || !datoN)
    {
        free(nue);
        free(datoN);
        return SIN_MEMORIA;
    }

    memcpy(datoN, dato, tam);
    nue->dato = datoN;
    nue->tam = tam;
    nue->sig = *pl;
    *pl = nue;

    return TODO_OK;
}
int insertarListaAlFinal(Lista* pl, const void* dato, size_t tam) //inserto al final
{
    while(*pl)
        pl = &(*pl)->sig;

    Nodo* nue = (Nodo*)malloc(sizeof(Nodo));
    void* datoN = malloc(tam);

    if (!nue || !datoN)
    {
        free(nue);
        free(datoN);
        return SIN_MEMORIA;
    }

    memcpy(datoN, dato, tam);
    nue->dato = datoN;
    nue->tam = tam;
    nue->sig = *pl;
    *pl = nue;

    return TODO_OK;
}
int insertarListaAlPrincipio(Lista* pl, const void* dato, size_t tam) //inserto en pos 0 y muevo todo
{
    Nodo* nue = (Nodo*)malloc(sizeof(Nodo));
    void* datoN = malloc(tam);

    if (!nue || !datoN)
    {
        free(nue);
        free(datoN);
        return SIN_MEMORIA;
    }

    memcpy(datoN, dato, tam);
    nue->dato = datoN;
    nue->tam = tam;
    nue->sig = *pl;
    *pl = nue;

    return TODO_OK;
}
int insertarListaEnPos(Lista* pl, const void* dato, size_t tam, unsigned pos)
{
    int i=0;
    while (i<pos && *pl)
    {
        pl = &(*pl)->sig;
        i++;
    }
    if (!*pl || i<pos)
        return 0;

    Nodo* nue = (Nodo*)malloc(sizeof(Nodo));
    void* datoN = malloc(tam);

    if (!nue || !datoN)
    {
        free(nue);
        free(datoN);
        return SIN_MEMORIA;
    }

    memcpy(datoN, dato, tam);
    nue->dato = datoN;
    nue->tam = tam;
    nue->sig = *pl;
    *pl = nue;

    return TODO_OK;
}
///buscar
int buscarPosLista(const Lista* pl, const void* dato, size_t tam, Cmp cmp)
{
    Nodo *pun = *pl;
    int cont=0;
    while(pun && (cmp(dato,pun->dato) != 0))
    {
        pun = pun->sig;
        cont++;
    }
    if (pun && (cmp(dato,pun->dato) == 0))
        return cont;
    return 0;
}
int buscarPorClaveGuardaDatos(const Lista* pl, void* dato, size_t tam, Cmp cmp)
{
    Nodo *pun = *pl;
    int cont=0;
    while(pun && (cmp(dato,pun->dato) != 0))
    {
        pun = pun->sig;
        cont++;
    }
    if (pun && (cmp(dato,pun->dato) == 0))
    {
        memcpy(dato,pun->dato,MIN(tam,pun->tam));
        return cont;
    }
    return 0;
}
int buscarPorPosicion(Lista *pl, void* dato, int pos, size_t tam)
{
    int contador = 0;
    while(*pl && contador < pos)
    {
        pl = &(*pl)->sig;
        contador++;
    }

    if(!*pl || contador < pos)
        return 0;

    memcpy(dato, (*pl)->dato, MIN(tam, (*pl)->tam));
    return 1;
}
int buscarMenor(Lista *pl, Cmp cmp, void* dato, size_t tam)
{
    if (!*pl)
        return -1;
    int cont=0, band=0, pos=-1;
    while(*pl)
    {
        if (cmp((*pl)->dato, dato)< 0 || band==0)
        {
            memcpy(dato,(*pl)->dato,MIN(tam, (*pl)->tam));
            pos=cont;
            band=1;
        }
        pl = &(*pl)->sig;
        cont++;
    }
    return pos;
}
int buscarMayor(Lista *pl, Cmp cmp, void* dato, size_t tam)
{
    if (!*pl)
        return -1;
    int cont=0, band=0, pos=-1;
    while(*pl)
    {
        if (cmp((*pl)->dato, dato) > 0 || band==0)
        {
            memcpy(dato,(*pl)->dato,MIN(tam, (*pl)->tam));
            pos=cont;
            band=1;
        }
        pl = &(*pl)->sig;
        cont++;
    }
    return pos;
}
///eliminar
int eliminarOrdPorClave(Lista* pl, void* dato, size_t tam, Cmp cmp)
{
    while(*pl && (cmp(dato,(*pl)->dato) > 0))
        pl = &(*pl)->sig;
    if (!*pl || (cmp(dato,(*pl)->dato) < 0))
        return 0;

    Nodo* nae = *pl;
    *pl = nae->sig;

    memcpy(dato,nae->dato,MIN(tam,nae->tam));

    free(nae->dato);
    free(nae);

    return 1;
}
int eliminarDesordPorClave(Lista* pl, void* dato, size_t tam, Cmp cmp)
{
    while(*pl && (cmp(dato,(*pl)->dato) != 0))
        pl = &(*pl)->sig;
    if (!*pl || (cmp(dato,(*pl)->dato) != 0))
        return 0;

    Nodo* nae = *pl;
    *pl = nae->sig;

    memcpy(dato,nae->dato,MIN(tam,nae->tam));

    free(nae->dato);
    free(nae);

    return 1;
}
int eliminarPorCondicion(Lista* pl, Condicion condicion)
{
    int cantElim=0;
    while(*pl)
    {
        if (condicion((*pl)->dato))
        {
            Nodo* nae = *pl;
            *pl = nae->sig;

            free(nae->dato);
            free(nae);

            cantElim++;
        }
        else
            pl = &(*pl)->sig;
    }

    return cantElim;
}
int eliminarDePos(Lista* pl, void* dato, size_t tam, unsigned pos)
{
    int i=0;
    while (i<pos && *pl)
    {
        pl = &(*pl)->sig;
        i++;
    }
    if (!*pl || i<pos)
        return 0;

    Nodo* nae = *pl;
    *pl = nae->sig;

    memcpy(dato,nae->dato,MIN(tam,nae->tam));

    free(nae->dato);
    free(nae);

    return 1;
}
int eliminarPrimero(Lista* pl, void* dato, size_t tam) //primero en la lista <-
{
    if (!*pl)
        return 0;

    Nodo* nae = *pl;
    *pl = nae->sig;

    memcpy(dato,nae->dato,MIN(tam,nae->tam));

    free(nae->dato);
    free(nae);

    return 1;
}
int eliminarUltimo(Lista* pl, void* dato, size_t tam) //ultimo en la lista ->
{
    if (!*pl)
        return 0;

    while(*pl && (*pl)->sig != NULL)
        pl = &(*pl)->sig;

    Nodo* nae = *pl;
    *pl = nae->sig;

    memcpy(dato,nae->dato,MIN(tam,nae->tam));

    free(nae->dato);
    free(nae);

    return 1;
}
int eliminarDuplicadosListaOrdAct(Lista* pl, Cmp cmp, Actualizar actualizar)
{
    int cantElim = 0;
    Lista* pl2 = pl;
    Nodo* nae;

    while (*pl2)
    {
        pl2 = &(*pl)->sig;
        while(*pl2 && cmp((*pl)->dato,(*pl2)->dato) == 0)
        {
            nae = *pl2;
            *pl2 = nae->sig;

            actualizar((*pl)->dato, nae->dato);

            free(nae->dato);
            free(nae);

            cantElim++;
        }
        pl = &(*pl)->sig;
    }

    return cantElim;
}
int eliminarDuplicadosListaNoOrdAct(Lista* pl, Cmp cmp, Actualizar actualizar)
{
    int cantElim = 0;
    Lista* pl2;
    Nodo* nae;

    while(*pl)
    {
        pl2 = &(*pl)->sig;
        while(*pl2)
        {
            if(cmp((*pl)->dato,(*pl2)->dato) == 0)
            {
                actualizar((*pl)->dato,(*pl2)->dato);
                nae = *pl2;
                *pl2 = nae->sig;

                free(nae->dato);
                free(nae);

                cantElim++;
            }
            else
                pl2 = &(*pl2)->sig;
        }
        pl = &(*pl)->sig;
    }

    return cantElim;
}
int eliminarDuplicadosListaOrd(Lista* pl, Cmp cmp)
{
    int cantElim = 0;
    Lista* pl2 = pl;
    Nodo* nae;

    while (*pl2)
    {
        pl2 = &(*pl)->sig;
        while(*pl2 && cmp((*pl)->dato,(*pl2)->dato) == 0)
        {
            nae = *pl2;
            *pl2 = nae->sig;

            free(nae->dato);
            free(nae);

            cantElim++;
        }
        pl = &(*pl)->sig;
    }

    return cantElim;

}
int eliminarDuplicadosListaNoOrd(Lista* pl, Cmp cmp)
{
    int cantElim = 0;
    Lista* pl2;
    Nodo* nae;

    while(*pl)
    {
        pl2 = &(*pl)->sig;
        while(*pl2)
        {
            if( cmp((*pl)->dato,(*pl2)->dato) == 0)
            {
                nae = *pl2;
                *pl2 = nae->sig;

                free(nae->dato);
                free(nae);

                cantElim++;
            }
            else
                pl2 = &(*pl2)->sig;
        }
        pl = &(*pl)->sig;
    }

    return cantElim;
}
///recorrer
void recorrerLista(Lista* pl, Accion accion, void* datosAccion)
{
    while(*pl)
    {
         accion((*pl)->dato,datosAccion);
         pl = &(*pl)->sig;
    }
}
///ordenar
int ordenarAsc(Lista* pl, Cmp cmp)
{
    if (!*pl)
        return 0;

    Lista lOrd = NULL;
    Lista* plOrd = &lOrd;
    Nodo* nodo;

    while (*pl)
    {
        nodo = *pl; //desengancho
        *pl = nodo->sig;

        plOrd = &lOrd;
        while(*plOrd && (cmp(nodo->dato,(*plOrd)->dato) > 0))
            plOrd = &(*plOrd)->sig;

        nodo->sig = *plOrd; //engancho
        *plOrd = nodo;
    }
    *pl = *(&lOrd);

    return 1;
}
int ordenarDesc(Lista* pl, Cmp cmp)
{
   if (!*pl)
        return 0;

    Lista lOrd = NULL;
    Lista* plOrd = &lOrd;
    Nodo* nodo;

    while (*pl)
    {
        nodo = *pl; //desengancho
        *pl = nodo->sig;

        plOrd = &lOrd;
        while(*plOrd && cmp(nodo->dato,(*plOrd)->dato) < 0)
            plOrd = &(*plOrd)->sig;

        nodo->sig = *plOrd; //engancho
        *plOrd = nodo;
    }
    *pl = *(&lOrd);

    return 1;
}
