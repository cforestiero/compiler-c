#ifndef LISTA_H_INCLUDED
#define LISTA_H_INCLUDED

#include <stddef.h>
#include "ListaImplDinamica.h"

#define MIN(x,y) (x<y)? (x) : (y)

#define TODO_OK 0
#define DUPLICADO 1
#define SIN_MEMORIA 2

typedef int (*Cmp)(const void* e1, const void* e2);
typedef void (*Actualizar)(void* actualizado, const void* actualizador);
typedef int (*Condicion)(const void* e);
typedef void (*Accion)(void* elem, void* datosAccion);

void crearLista(Lista* pl);
void vaciarLista(Lista* pl);

int listaVacia(const Lista* pl);
int listaLlena(const Lista *pl, size_t tam);
int verPrimeroLista(Lista *pl, void *dato, size_t tam);
int verUltimoLista(Lista *pl, void *dato, size_t tam);

int contarElementos(const Lista *pl);
int contarElementosPorClaveOrd(const Lista *pl, const void* dato, Cmp cmp);
int contarElementosPorClaveDesord(const Lista *pl, const void* dato, Cmp cmp);//

int insertarListaOrdSinDupli(Lista* pl, const void* dato, size_t tam, Cmp cmp);
int insertarOActualizarListaOrd(Lista* pl, const void* dato, size_t tam, Cmp cmp, Actualizar actualizar);
int insertarListaAlFinal(Lista* pl, const void* dato, size_t tam);
int insertarListaAlPrincipio(Lista* pl, const void* dato, size_t tam);
int insertarListaEnPos(Lista* pl, const void* dato, size_t tam, unsigned pos); //

int buscarPosLista(const Lista* pl, const void* dato, size_t tam, Cmp cmp); //
int buscarMenor(Lista *pl, Cmp cmp, void *dato, size_t tam); //primer menor que dato NO menor de la lista //
int buscarMayor(Lista *pl, Cmp cmp, void *dato, size_t tam); //primer mayor que dato NO mayor de la lista //
int buscarPorClaveGuardaDatos(const Lista* pl, void* dato, size_t tam, Cmp cmp); //

int eliminarOrdPorClave(Lista* pl, void* dato, size_t tam, Cmp cmp);
int eliminarDesordPorClave(Lista* pl, void* dato, size_t tam, Cmp cmp); //
int eliminarPorCondicion(Lista* pl, Condicion condicion); //
int eliminarDePos(Lista* pl, void* dato, size_t tam, unsigned pos);
int eliminarPrimero(Lista* pl, void* dato, size_t tam);
int eliminarUltimo(Lista* pl, void* dato, size_t tam);
int eliminarDuplicadosListaOrdAct(Lista* pl, Cmp cmp, Actualizar actualizar);
int eliminarDuplicadosListaNoOrdAct(Lista* pl, Cmp cmp, Actualizar actualizar);
int eliminarDuplicadosListaOrd(Lista* pl, Cmp cmp);
int eliminarDuplicadosListaNoOrd(Lista* pl, Cmp cmp);

void recorrerLista(Lista* pl, Accion accion, void* datosAccion);

int ordenarAsc(Lista* pl, Cmp cmp);
int ordenarDesc(Lista* pl, Cmp cmp);

int top5 (Lista* pl, Cmp);


#endif // LISTA_H_INCLUDED
