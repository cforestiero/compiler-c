%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "y.tab.h"
#include "Lista.h"
#include "symbol_table.h"
#include "Tercetos.h"

extern Lista lista_simbolos;

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();
char* formatear(int indice);
char* formatearComparador(char* comparador);

void reemplazarEspaciosPorGuionBajo(char* str);
int compararIndices(const void* a, const void* b);
int compararEtiq(const void* a, const void* b);
void eliminar_corchetes(char *texto);
void generar_assembler(char* nombre_archivo_asm, char* nombre_archivo_tabla, char* nombre_archivo_tercetos);

char* nombre_archivo_tabla = "symbol-table.txt";
char* nombre_archivo_tercetos = "intermediate-code.txt";
char* nombre_archivo_asm = "final.asm";
char *tipoObtenidoExpresionComparacion;

int AsignacionInd;
int ExpresionInd;
int TerminoInd;
int FactorInd;
int ProgramaInd;
int BloqueInd;
int SentenciaInd;
int ElementoInd;
int ListaInd;
int IteracionInd; 
int SeleccionInd; 
int EscrituraInd; 
int LecturaInd;
int EntradaInd;
int SalidaInd;
int TrianguloInd;
int Xind;
int ComparacionInd;

int CondicionTipo;

int listaCreada = 0;
Lista ListaAignaciones;
Lista ListaComparaciones;
Lista ListaComparadores;
Lista ListaCondicionesTipo;
Lista ListaExpresiones;

typedef struct {
    char indice[150];
    char variable[150];       
} datoAsm;

%}

%union {
    char* s;
}

%token <s> CTE_ENTERA
%token <s> CTE_REAL
%token <s> CTE_CADENA
%token <s> CTE_BINARIA
%token <s> ID
%token OP_ASIG
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV
%token PAR_A
%token PAR_C
%token LLAVE_A
%token LLAVE_C
%token CORCHETE_A
%token CORCHETE_C
%token COMA
%token PUNTO
%token DOS_PUNTOS
%token COMP_MAYOR
%token COMP_MENOR
%token COMP_MAYORIGUAL
%token COMP_MENORIGUAL
%token COMP_IGUAL
%token COMP_DISTINTO
%token BINARYCOUNT
%token TRIANGULO
%token MIENTRAS
%token SINO
%token SI
%token ESCRIBIR
%token LEER
%token FLOAT
%token INT
%token STRING
%token BINARIO
%token AND
%token OR
%token NOT
%token INIT
%type <s> tipo_de_dato
%type <s> elemento
%type <s> expresion


%left '+''-'
%left '*''/'
%right MENOS_UNARIO

%%

programa:
        init {
                crearLista(&ListaComparaciones);
                crearLista(&ListaComparadores);
                crearLista(&ListaCondicionesTipo);
        }
        bloque {
                printf("                El analizador sintactico reconoce a: <Programa> --> <Init> <Bloque>\n\n");
                
                guardarTablaDeSimbolos(nombre_archivo_tabla);
                guardarTercetos(nombre_archivo_tercetos);
                generar_assembler(nombre_archivo_asm, nombre_archivo_tabla, nombre_archivo_tercetos);
                
                ProgramaInd = BloqueInd;
        }
        ;

bloque:
        bloque sentencia {
                BloqueInd = SentenciaInd;
                printf("                El analizador sintactico reconoce a: <Bloque> --> <Bloque> <Sentencia>\n\n");}
        | sentencia {
                BloqueInd = SentenciaInd;
                printf("                El analizador sintactico reconoce: <Bloque> --> <Sentencia>\n\n");}
        ;

init:
        INIT LLAVE_A bloque_declaracion LLAVE_C {
                printf("                El analizador sintactico reconoce: <Init> --> INIT LLAVE_A <Bloque_declaracion> LLAVE_C\n\n");}
        ;

bloque_declaracion:
        bloque_declaracion declaracion {   
                printf("                El analizador sintactico reconoce: <Bloque_declaracion> --> <Bloque_declaracion> <Declaracion> es \n\n");}
        | declaracion {
                printf("                El analizador sintactico reconoce: <Bloque_declaracion> --> <Declaracion>\n\n");}
        ;

declaracion:
        lista_de_variables DOS_PUNTOS tipo_de_dato {
                char aux[sizeof(char[500])] ;
                while (!listaVacia(&ListaAignaciones)) {
                        eliminarPrimero(&ListaAignaciones, aux, sizeof(char[500]));
                        if(agregarSimbolo(aux,$3,"","") != TODO_OK) {
                                exit(1);
                        }          
                }
           
                printf("                El analizador sintactico reconoce: <Declaracion> --> <Lista_de_variables> DOS_PUNTOS <Tipo_de_dato>\n\n");
        }
        ;

lista_de_variables:
        lista_de_variables COMA ID {
                
                if(insertarListaOrdSinDupli(&ListaAignaciones, $3, sizeof(char[500]), compararArrojandoError) != TODO_OK || buscarEnLista(&lista_simbolos,$3,compararArrojandoError) != TODO_OK){
                        printf("Error Semantico: Variable duplicada. Ya fue definida anteriormente.\n");
                        exit(1);
                }
                printf("                El analizador sintactico reconoce: <Lista_de_variables> --> <Lista_de_variables> COMA ID\n\n");
        }
        | ID {
                if(!listaCreada){
                        
                        crearLista(&ListaAignaciones);
                        listaCreada = 1;
                }
              
                if(insertarListaOrdSinDupli(&ListaAignaciones, $1, sizeof(char[500]), compararArrojandoError) != TODO_OK || buscarEnLista(&lista_simbolos,$1,compararArrojandoError) != TODO_OK){
                        printf("Error Semantico: Variable duplicada. Ya fue definida anteriormente.\n");
                        exit(1);
                }

                printf("                El analizador sintactico reconoce: <Lista_de_variables> --> ID\n\n");
        }
        ;

tipo_de_dato:
        INT {                       
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> INT\n\n");}
        | FLOAT {
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> FLOAT\n\n");}
        | STRING { 
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> STRING\n\n");}
        | BINARIO { 
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> BINARIO\n\n");}
        ;

sentencia:
        asignacion {
                SentenciaInd = AsignacionInd;

                printf("                El analizador sintactico reconoce: <Sentencia> --> <asignacion>\n\n");
        }
        | iteracion {
                SentenciaInd = IteracionInd;

                printf("                El analizador sintactico reconoce: <Sentencia> --> <iteracion>\n\n");
        }
        | seleccion {
                SentenciaInd = SeleccionInd;
                
                printf("                El analizador sintactico reconoce: <Sentencia> --> <seleccion>\n\n");
        }                           
        | escritura {
                SentenciaInd = EscrituraInd;
                
                printf("                El analizador sintactico reconoce: <Sentencia> --> <escritura>\n\n");
        }
        | lectura {
                SentenciaInd = LecturaInd;

                printf("                El analizador sintactico reconoce: <Sentencia> --> <lectura>\n\n");
        }
        ;

asignacion:
         ID OP_ASIG expresion {
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);

                if(strcmp(tipoObtenido,"String")==0){
                     printf("ERROR SEMANTICO: %s es del tipo String, asignacion invalida.\n", $1);
                     exit(1);   
                }

                if(strcmp(tipoObtenido,"Binario")==0){
                     printf("ERROR SEMANTICO: %s es del tipo Binario, asignacion invalida.\n", $1);
                     exit(1);   
                }

                char *tipoObtenido2;
                tipoObtenido2 = retornarTipoDeDato($3);

                if(strcmp("",tipoObtenido2) != 0){
                        if(strcmp(tipoObtenido,tipoObtenido2) != 0){
                        printf("ERROR SEMANTICO: Asignacion de datos de distinto tipo.\n", $1);
                        exit(1);   
                        }
                }        

                AsignacionInd = agregarTerceto(":=", $1, formatear(ExpresionInd));
                
                printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <Expresion>\n\n");
        }

        | ID OP_ASIG funcion_triangulo {
                printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <funcion_triangulo>\n");
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);

                if(strcmp(tipoObtenido,"String")!=0){
                     printf("ERROR SEMANTICO: %s no es del tipo String, asignacion invalida.\n", $1);
                     exit(1);   
                }

                AsignacionInd = agregarTerceto(":=", $1, "@resultado");
        }

        | ID OP_ASIG funcion_binaryCount {
                printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <funcion_binaryCount>\n");
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);
                if(strcmp(tipoObtenido,"Int")!=0){
                     printf("ERROR SEMANTICO: %s no es del tipo Int, asignacion invalida.\n", $1);
                     exit(1);   
                }

                AsignacionInd = agregarTerceto(":=", $1, "@contBinarios");
        }

        | ID OP_ASIG CTE_CADENA {
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);
                if(strcmp(tipoObtenido,"String")!=0){
                     printf("ERROR SEMANTICO: %s no es del tipo String, asignacion invalida.\n", $1);
                     exit(1);   
                }
                AsignacionInd = agregarTerceto(":=", $1, $3);
                
                printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG CTE_CADENA\n\n");
        }

        | ID OP_ASIG CTE_BINARIA {
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);
                if(strcmp(tipoObtenido,"Binario")!=0){
                     printf("ERROR SEMANTICO: %s no es del tipo Binario, asignacion invalida.\n", $1);
                     exit(1);   
                }
                AsignacionInd = agregarTerceto(":=", $1, $3);
                
                printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG CTE_BINARIA\n\n");
        }
        ;

seleccion:
        SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C seleccion_sino
        
        ;

seleccion_sino:
        /* vacio */ {

                printf("                El analizador sintactico reconoce: <Seleccion> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C\n\n");
                
                int auxCompracion;
                verUltimoLista(&ListaCondicionesTipo, &auxCompracion, sizeof(int));
                int auxIndice;
                
                switch(auxCompracion){
                        case 1:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTerceto(auxIndice,formatear(BloqueInd+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                        case 2:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTerceto(auxIndice,formatear(BloqueInd+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTerceto(auxIndice,formatear(BloqueInd+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                        case 3:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTerceto(auxIndice,formatear(BloqueInd+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));

                                int segundaCond = auxIndice;
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTercetoInver(auxIndice);
                                actualizarTerceto(auxIndice,formatear(segundaCond+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                        case 4:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTercetoInver(auxIndice);
                                actualizarTerceto(auxIndice,formatear(BloqueInd+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                } 
                eliminarUltimo(&ListaComparaciones, &auxCompracion, sizeof(int));
                SeleccionInd = BloqueInd;

                printf("                El analizador sintactico reconoce: <Seleccion> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C SINO LLAVE_A <Bloque> LLAVE_C\n\n");
        }
        | SINO {
                int auxCompracion;
                verUltimoLista(&ListaCondicionesTipo, &auxCompracion, sizeof(int));
                int auxIndice;
                
                switch(auxCompracion){
                        case 1:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTerceto(auxIndice,formatear(BloqueInd+2));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                        case 2:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                
                                actualizarTerceto(auxIndice,formatear(BloqueInd+2));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                
                                actualizarTerceto(auxIndice,formatear(BloqueInd+2));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                        case 3:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTerceto(auxIndice,formatear(BloqueInd+2));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));

                                int segundaCond = auxIndice;
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTercetoInver(auxIndice);
                                actualizarTerceto(auxIndice,formatear(segundaCond+1));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                        case 4:
                                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTercetoInver(auxIndice);
                                actualizarTerceto(auxIndice,formatear(BloqueInd+2));
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                break;
                } 
                eliminarUltimo(&ListaComparaciones, &auxCompracion, sizeof(int));
                
                SeleccionInd = agregarTerceto("BI",formatear(auxIndice),"_");
                insertarListaAlFinal(&ListaComparaciones, &SeleccionInd, sizeof(SeleccionInd));
        }
        LLAVE_A bloque LLAVE_C {
                int auxIndice;
                
                verUltimoLista(&ListaComparaciones, &auxIndice, sizeof(int));
                actualizarTerceto(auxIndice,formatear(BloqueInd+1));
                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));

                SeleccionInd = BloqueInd;

                printf("                El analizador sintactico reconoce: <Seleccion_sino> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C SINO LLAVE_A <Bloque> LLAVE_C\n\n");
        }
        ;


condicion:
        comparacion {
                printf("                El analizador sintactico reconoce: <Condicion> --> <Comparacion>\n\n");
                CondicionTipo = 1;
                insertarListaAlFinal(&ListaCondicionesTipo, &CondicionTipo, sizeof(int));
        }
        | comparacion AND comparacion {
                printf("                El analizador sintactico reconoce: <Condicion> --> <Comparacion> AND <Comparacion>\n\n");
                CondicionTipo = 2;
                insertarListaAlFinal(&ListaCondicionesTipo, &CondicionTipo, sizeof(int));

        }
        | comparacion OR comparacion {
                printf("                El analizador sintactico reconoce: <Condicion> --> <Comparacion> OR <Comparacion>\n\n");
                CondicionTipo = 3;
                insertarListaAlFinal(&ListaCondicionesTipo, &CondicionTipo, sizeof(int));

        }
        | NOT comparacion {
                printf("                El analizador sintactico reconoce: <Condicion> --> NOT <Comparacion>\n\n");
                CondicionTipo = 4;
                insertarListaAlFinal(&ListaCondicionesTipo, &CondicionTipo, sizeof(int));
        }
        ;

comparacion:
        expresion {
                ComparacionInd = ExpresionInd;

                tipoObtenidoExpresionComparacion = retornarTipoDeDato($1);
                }
        comparador expresion {
                
                printf("                El analizador sintactico reconoce: <Comparacion> --> <Expresion> <Comparador> <Expresion>\n\n");
                
                char *tipoObtenido2;
                tipoObtenido2 = retornarTipoDeDato($4);

                if(strcmp(tipoObtenidoExpresionComparacion,"") != 0 && strcmp(tipoObtenido2,"") != 0){
                        if(strcmp(tipoObtenidoExpresionComparacion,tipoObtenido2) != 0){
                        printf("ERROR SEMANTICO: Comparacion de variables de distinto tipo.\n");
                        exit(1);   
                        }
                }

                agregarTerceto("CMP",formatear(ComparacionInd),formatear(ExpresionInd));
                
                char auxComparador[2];
                verUltimoLista(&ListaComparadores, auxComparador, sizeof(auxComparador));
                ComparacionInd = agregarTerceto(formatearComparador(auxComparador), "_", "_");

                eliminarUltimo(&ListaComparadores, auxComparador, sizeof(auxComparador));

                insertarListaAlFinal(&ListaComparaciones, &ComparacionInd, sizeof(ComparacionInd));   
                
        }
        ;

comparador:
        COMP_MAYOR {
                insertarListaAlFinal(&ListaComparadores, ">", sizeof(char[2]));
                printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MAYOR\n\n");
        }
        | COMP_MENOR {
                insertarListaAlFinal(&ListaComparadores, "<", sizeof(char[2]));
                printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MENOR\n\n");
        }
        | COMP_MAYORIGUAL {
                insertarListaAlFinal(&ListaComparadores, ">=", sizeof(char[2]));
                printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MAYORIGUAL\n\n");
        }
        | COMP_MENORIGUAL {
                insertarListaAlFinal(&ListaComparadores, "<=", sizeof(char[2]));
                printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MENORIGUAL\n\n");
        }
        | COMP_IGUAL { 
                insertarListaAlFinal(&ListaComparadores, "==", sizeof(char[2]));
                printf("                El analizador sintactico reconoce: <Comparador> --> COMP_IGUAL\n\n");
        }
        | COMP_DISTINTO {
                insertarListaAlFinal(&ListaComparadores, "!=", sizeof(char[2]));
                printf("                El analizador sintactico reconoce: <Comparador> --> COMP_DISTINTO\n\n");
        }
        ; 

iteracion:
        MIENTRAS PAR_A {
                int aux_etiqueta_while = agregarTerceto("ETIQUETA_INICIO_WHILE","_","_");
                insertarListaAlFinal(&ListaComparaciones, &aux_etiqueta_while, sizeof(aux_etiqueta_while));

        }
        condicion PAR_C LLAVE_A bloque {
                int auxCompracion;
                eliminarUltimo(&ListaCondicionesTipo, &auxCompracion, sizeof(int));

                int auxIndice, auxIndice2;
                int aux_etiqueta_while;

                switch(auxCompracion){
                        case 1:
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                eliminarUltimo(&ListaComparaciones, &aux_etiqueta_while, sizeof(int));

                                IteracionInd = agregarTerceto("BI",formatear(aux_etiqueta_while),"_");
                                actualizarTerceto(auxIndice,formatear(IteracionInd + 1));
                                break;
                        case 2:
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                eliminarUltimo(&ListaComparaciones, &auxIndice2, sizeof(int));
                                eliminarUltimo(&ListaComparaciones, &aux_etiqueta_while, sizeof(int));

                                IteracionInd = agregarTerceto("BI",formatear(aux_etiqueta_while),"_");
                                actualizarTerceto(auxIndice,formatear(IteracionInd + 1));
                                actualizarTerceto(auxIndice2,formatear(IteracionInd + 1));

                                break;
                        case 3:
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                eliminarUltimo(&ListaComparaciones, &auxIndice2, sizeof(int));
                                eliminarUltimo(&ListaComparaciones, &aux_etiqueta_while, sizeof(int));


                                IteracionInd = agregarTerceto("BI",formatear(aux_etiqueta_while),"_");
                                actualizarTerceto(auxIndice,formatear(IteracionInd + 1));
                                actualizarTercetoInver(auxIndice2);
                                actualizarTerceto(auxIndice2,formatear(auxIndice+1));

                                break;
                        case 4:
                                eliminarUltimo(&ListaComparaciones, &auxIndice, sizeof(int));
                                actualizarTercetoInver(auxIndice);
                                eliminarUltimo(&ListaComparaciones, &aux_etiqueta_while, sizeof(int));

                                IteracionInd = agregarTerceto("BI",formatear(aux_etiqueta_while),"_");
                                actualizarTerceto(auxIndice,formatear(IteracionInd + 1));
                                break;
                } 

        }
        LLAVE_C {printf("                El analizador sintactico reconoce: <Iteracion> --> MIENTRAS PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C \n\n");}
        ;

escritura:
        ESCRIBIR PAR_A salida PAR_C {
                printf("                El analizador sintactico reconoce: <Escritura> --> ESCRIBIR PAR_A <Salida> PAR_C\n\n");
                
                EscrituraInd= agregarTerceto("ESCRIBIR",formatear(SalidaInd),"_");
        }
        ;

salida:
        ID {
                printf("                El analizador sintactico reconoce: <Salida> --> ID\n\n");
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                SalidaInd= agregarTerceto($1,"_","_");
        }
        | CTE_CADENA {
                printf("                El analizador sintactico reconoce: <Salida> --> CTE_CADENA\n\n");
                SalidaInd= agregarTerceto($1,"_","_");
        }
        | CTE_ENTERA {
                printf("                El analizador sintactico reconoce: <Salida> --> CTE_ENTERA\n\n");
                SalidaInd= agregarTerceto($1,"_","_");
        }
        | CTE_REAL {
                printf("                El analizador sintactico reconoce: <Salida> --> CTE_REAL\n\n");
                SalidaInd= agregarTerceto($1,"_","_");
        }
        ;

lectura:
        LEER PAR_A entrada PAR_C {
                printf("                El analizador sintactico reconoce: <Lectura> --> LEER PAR_A <Entrada> PAR_C\n\n");
                LecturaInd= agregarTerceto("LEER",formatear(EntradaInd),"_");
        }
        ;

entrada:
        ID {
                printf("                El analizador sintactico reconoce: <Entrada> --> ID\n\n");
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                EntradaInd= agregarTerceto($1,"_","_");
        }
        ;

expresion:
        termino {
                ExpresionInd = TerminoInd;

                printf("                El analizador sintactico reconoce: <Expresion> --> <Termino>\n\n");}
        | expresion OP_SUM termino {
                ExpresionInd = agregarTerceto("+",formatear(ExpresionInd), formatear(TerminoInd));
                
                printf("                El analizador sintactico reconoce: <Expresion> --> <Expresion> OP_SUM <Termino>\n\n");}
        | expresion OP_RES termino {
                ExpresionInd = agregarTerceto("-",formatear(ExpresionInd), formatear(TerminoInd));
                
                printf("                El analizador sintactico reconoce: <Expresion> --> <Expresion> OP_RES <Termino>\n\n");}
    ;

termino: 
        factor {TerminoInd = FactorInd;
                
                printf("                El analizador sintactico reconoce: <Termino> --> <Factor>\n\n");}
        |termino OP_MUL factor {
                TerminoInd = agregarTerceto("*",formatear(TerminoInd), formatear(FactorInd));
                
                printf("                El analizador sintactico reconoce: <Termino> --> <Termino> OP_MUL <Factor>\n\n");}
        |termino OP_DIV factor {
                TerminoInd = agregarTerceto("/",formatear(TerminoInd), formatear(FactorInd));
                
                printf("                El analizador sintactico reconoce: <Termino> --> <Termino> OP_DIV <Factor>\n\n");}
       ;

factor: 
        ID {
                printf("                El analizador sintactico reconoce: <Factor> --> ID\n\n");
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }

                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);
                if(strcmp(tipoObtenido,"String") == 0 || strcmp(tipoObtenido,"Binario") == 0){
                     printf("ERROR SEMANTICO: Asignacion incorrecta.\n");
                     exit(1);   
                }

                FactorInd = agregarTerceto($1, "_", "_"); 
        }
        | CTE_ENTERA {   
                FactorInd = agregarTerceto($1, "_", "_"); 
                printf("                El analizador sintactico reconoce: <Factor> --> CTE_ENTERA\n\n");
        }

        | CTE_REAL {
                FactorInd = agregarTerceto($1, "_", "_"); 
                printf("                El analizador sintactico reconoce: <Factor> --> CTE_REAL\n\n");
        }

        | PAR_A {
                crearLista(&ListaExpresiones);
                insertarListaAlFinal(&ListaExpresiones, &ExpresionInd, sizeof(int));
                insertarListaAlFinal(&ListaExpresiones, &TerminoInd, sizeof(int));
        }
        expresion PAR_C {
                FactorInd = ExpresionInd;
                eliminarPrimero(&ListaExpresiones, &TerminoInd, sizeof(int));
                eliminarPrimero(&ListaExpresiones, &ExpresionInd, sizeof(int));

                printf("                El analizador sintactico reconoce: <Factor> --> PAR_A <Expresion> PAR_C\n\n");
        }

        | OP_RES PAR_A {
                crearLista(&ListaExpresiones);
                insertarListaAlFinal(&ListaExpresiones, &ExpresionInd, sizeof(int));
                insertarListaAlFinal(&ListaExpresiones, &TerminoInd, sizeof(int));
        }
        expresion PAR_C %prec MENOS_UNARIO {
                FactorInd = agregarTerceto("-", "0", formatear(ExpresionInd)); 
                eliminarPrimero(&ListaExpresiones, &TerminoInd, sizeof(int));
                eliminarPrimero(&ListaExpresiones, &ExpresionInd, sizeof(int));

                printf("                El analizador sintactico reconoce: <Factor> --> -(<Expresion>)\n\n");
        }

        | OP_RES ID %prec MENOS_UNARIO {
                printf("                El analizador sintactico reconoce: <Factor> --> - ID\n\n");
                if(validarVariableDeclarada($2) != TODO_OK){
                        exit(1);
                }
                FactorInd= agregarTerceto("-","0",$2);
        }
        ;

funcion_triangulo:
        TRIANGULO PAR_A lista_parametros PAR_C {
                printf("                El analizador sintactico reconoce: <Funcion_triangulo> --> TRIANGULO PAR_A <Lista_parametros> PAR_C\n\n");
                
                TrianguloInd = agregarTerceto("CMP","@lado1","@lado2");
                agregarTerceto("BNE",formatear(TrianguloInd+6),"_");
                agregarTerceto("CMP","@lado2","@lado3");
                agregarTerceto("BNE",formatear(TrianguloInd+6),"_");
                agregarTerceto(":=","@resultado","Equilatero");

                agregarTerceto("BI",formatear(TrianguloInd+15),"_");

                agregarTerceto("CMP","@lado1","@lado2");
                agregarTerceto("BEQ",formatear(TrianguloInd+12),"_");
                agregarTerceto("CMP","@lado1","@lado3");
                agregarTerceto("BEQ",formatear(TrianguloInd+12),"_");
                agregarTerceto("CMP","@lado2","@lado3");
                agregarTerceto("BNE",formatear(TrianguloInd+14),"_");
                agregarTerceto(":=","@resultado","Isosceles");

                agregarTerceto("BI",formatear(TrianguloInd+15),"_");
                
                TrianguloInd = agregarTerceto(":=","@resultado","Escaleno");

                agregarSimbolo("@resultado","String","","");
                agregarSimbolo("Equilatero","","Equilatero","10");
                agregarSimbolo("Isosceles","","Isosceles","9");
                agregarSimbolo("Escaleno","","Escaleno","8");
        }
        ;

lista_parametros:
        expresion {
                agregarTerceto(":=","@lado1",formatear(ExpresionInd));
                agregarSimbolo("@lado1","Float","","");
        }
        COMA expresion {
                agregarTerceto(":=","@lado2",formatear(ExpresionInd));
                agregarSimbolo("@lado2","Float","","");
        }
        COMA expresion { 
                agregarTerceto(":=","@lado3",formatear(ExpresionInd));
                agregarSimbolo("@lado3","Float","","");
                printf("                El analizador sintactico reconoce: <Lista_parametros> --> <Expresion> COMA <Expresion> COMA <Expresion>\n\n");
        }
        ;

funcion_binaryCount:
        BINARYCOUNT 
        {
              agregarTerceto(":=","@contBinarios", "0");  
              agregarSimbolo("@contBinarios","Int","","");
        }
        PAR_A CORCHETE_A lista CORCHETE_C PAR_C {
                printf("                El analizador sintactico reconoce: <Funcion_binaryCount> --> BINARYCOUNT PAR_A CORCHETE_A <Lista> CORCHETE_C PAR_C\n\n");
        }
        ;

lista:
        elemento {
                
                printf("                El analizador sintactico reconoce: <Lista> --> <Elemento>\n\n");
        }
        | lista COMA elemento {
                
                printf("                El analizador sintactico reconoce: <Lista> --> <Lista> COMA <Elemento>\n\n");
        }
        ;

elemento:
        ID {
                if(validarVariableDeclarada($1) != TODO_OK){
                        exit(1);
                }
                char *tipoObtenido;
                tipoObtenido = retornarTipoDeDato($1);
                if(strcmp(tipoObtenido,"Binario")==0){
                        int aux1 = agregarTerceto("@contBinarios", "_","_");
                        int aux2 = agregarTerceto("1", "_","_");
                        ElementoInd= agregarTerceto("+", formatear(aux1), formatear(aux2));
                        agregarTerceto(":=", "@contBinarios", formatear(ElementoInd));  
                        agregarSimbolo("1","","1","");
                }
                printf("                El analizador sintactico reconoce: <Elemento> --> ID\n\n");
                
        }
        | CTE_ENTERA {
                printf("                El analizador sintactico reconoce: <Elemento> --> CTE_ENTERA\n\n");
                
        }
        | CTE_REAL {
                printf("                El analizador sintactico reconoce: <Elemento> --> CTE_REAL\n\n");
              
        }
        | CTE_BINARIA {
                printf("                El analizador sintactico reconoce: <Elemento> --> CTE_BINARIA\n\n");
                int aux1 = agregarTerceto("@contBinarios", "_","_");
                int aux2 = agregarTerceto("1", "_","_");
                ElementoInd= agregarTerceto("+", formatear(aux1), formatear(aux2));
                agregarTerceto(":=", "@contBinarios", formatear(ElementoInd));
                agregarSimbolo("1","","1","");
        }
        ;

%%

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        
        yyparse();
        
    }
    fclose(yyin);

    return 0;
}

int yyerror(void)
{
    printf("Error Sintactico\n");
    exit(1);
}

char* formatear(int indice) {
    char* aux_corchetes = malloc(25); // Reserva memoria dinámica
    char aux[20];

    itoa(indice, aux, 10); // Convierte el índice a cadena
    sprintf(aux_corchetes, "[%s]", aux); // Formatea con corchetes

    return aux_corchetes; // Devuelve el puntero a la cadena dinámica
}

char* formatearComparador(char* comparador) {
    if (strcmp(comparador, "<") == 0) return "BGE";
    if (strcmp(comparador, ">") == 0) return "BLE";
    if (strcmp(comparador, "=") == 0) return "BNE";
    if (strcmp(comparador, "!") == 0) return "BEQ";
    if (strcmp(comparador, "<=") == 0) return "BGT";
    if (strcmp(comparador, ">=") == 0) return "BLT";
    return "Invalid comparator";
}

void reemplazarEspaciosPorGuionBajo(char* str) {
    while (*str) {
        if (*str == ' ') {
            *str = '_';  // Reemplazamos el espacio por un guion bajo
        }
        str++;
    }
}

void generar_assembler(char* nombre_archivo_asm, char* nombre_archivo_tabla, char* nombre_archivo_tercetos) {
   
        printf("GENERO ASSEMBLER\n");

    FILE *fileASM = fopen(nombre_archivo_asm, "w");

    if (fileASM == NULL) {
        printf("Error al intentar guardar el codigo assemblr en archivo %s.", nombre_archivo_asm);
        return;
    }

    fprintf(fileASM, "include number.asm\n");
    fprintf(fileASM, "include macros2.asm\n\n");
    

    fprintf(fileASM, ".MODEL LARGE\n");
    fprintf(fileASM, ".386\n");
    fprintf(fileASM, ".STACK 200h\n\n");
    fprintf(fileASM, "MAXTEXTSIZE equ 40\n\n");
    fprintf(fileASM, "\n.DATA\n");

    Lista dataLista = NULL;
    Lista ListaVariables = NULL;
    crearLista(&dataLista);
    crearLista(&ListaVariables);
    copiarTablaDeSimbolos(&dataLista);

    Nodo* current = dataLista;  // Aquí 'data' es de tipo Lista (puntero a Nodo)
    datoAsm dato;

    while (current != NULL) {
        simbolo* _simbolo = (simbolo*)current->dato;  // Obtener el símbolo desde el nodo

        // Escribir los datos del símbolo en el archivo
        if (_simbolo->valor[0] == '\0') {  // Si el valor está vacío
                if(strcmp(_simbolo->tipo_de_dato, "String") == 0) {
                        fprintf(fileASM, "s_%s\t\tdb MAXTEXTSIZE dup (?), '$'\n", _simbolo->nombre); //ids
                        strcpy(dato.indice, _simbolo->nombre);
                        sprintf(dato.variable, "s_%s", _simbolo->nombre);
                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                } else if(strcmp(_simbolo->tipo_de_dato, "Binario") == 0) {
                        fprintf(fileASM, "bin_%s\t\tdd\t\t?\n", _simbolo->nombre); //ids bin
                        strcpy(dato.indice, _simbolo->nombre);
                        sprintf(dato.variable, "bin_%s", _simbolo->nombre);
                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                } else {
                        fprintf(fileASM, "%s\t\tdd\t\t?\n", _simbolo->nombre); //ids
                        strcpy(dato.indice, _simbolo->nombre);
                        strcpy(dato.variable, _simbolo->nombre);
                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                }
        } else {                                                        //ctes
                if(_simbolo->longitud[0] != '\0'){                          //tiene longitud ==> es cadena
                        reemplazarEspaciosPorGuionBajo(_simbolo->nombre);
                        fprintf(fileASM, "_cte_cad_%s\t\tdb\t\t\"%s\",'$', %s dup (?)\n", _simbolo->nombre, _simbolo->valor, _simbolo->longitud);
                        strcpy(dato.indice, _simbolo->valor);
                        sprintf(dato.variable, "_cte_cad_%s", _simbolo->nombre);
                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                } else {   //no cadena
                        if(strchr(_simbolo->valor, '.') == NULL){             //es int 
                                if(strncmp(_simbolo->valor, "0b", 2) == 0) {                 //es binario  
                                        fprintf(fileASM, "_cte_bin_%s\t\tdb\t\t\"%s\",'$', MAXTEXTSIZE dup (?)\n", _simbolo->nombre, _simbolo->valor);
                                        strcpy(dato.indice, _simbolo->nombre);
                                        sprintf(dato.variable, "_cte_bin_%s", _simbolo->nombre);
                                        printf("GUARDO CTE CON EL INDICE: %s\n",dato.indice);
                                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                                }
                                else {
                                        fprintf(fileASM, "_cte_%s\t\tdd\t\t%s.0\n", _simbolo->nombre, _simbolo->valor); //paso a float
                                        strcpy(dato.indice, _simbolo->nombre);
                                        sprintf(dato.variable, "_cte_%s", _simbolo->nombre);
                                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                                }                               
                        } else{
                                if(_simbolo->valor[0] == '.') {// .5 ==> agrego cero ==> 0.5
                                        fprintf(fileASM, "_cte_0%s\t\tdd\t\t0%s\n", _simbolo->nombre, _simbolo->valor);
                                        strcpy(dato.indice, _simbolo->nombre);
                                        sprintf(dato.variable, "_cte_0%s", _simbolo->nombre);
                                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                                }
                                else {
                                        fprintf(fileASM, "_cte_%s\t\tdd\t\t%s\n", _simbolo->nombre, _simbolo->valor);
                                        strcpy(dato.indice, _simbolo->nombre);
                                        sprintf(dato.variable, "_cte_%s", _simbolo->nombre);
                                        insertarListaAlFinal(&ListaVariables,&dato,sizeof(dato));
                                }
                        }
                }
        }
        
        // Avanzar al siguiente nodo
        current = current->sig;
    }

    fprintf(fileASM, "\n.CODE\n");
    fprintf(fileASM, "\nSTART:\n\n");
    fprintf(fileASM, "mov  AX, @data\n");
    fprintf(fileASM, "mov  DS, AX\n");
    fprintf(fileASM, "mov  es, ax\n\n");


    Lista codigoLista = NULL;
    Lista pilaASM = NULL;
    Lista pilaCiclos = NULL;
    crearLista(&codigoLista);
    crearLista(&pilaASM);
    crearLista(&pilaCiclos);
    copiarListaDeTercetos(&codigoLista);

    current = codigoLista; 
    char operadorIzq[50], operadorDer[50];
    char etiquetaComparacion[50];
    int band;
    
    terceto* _terceto;

    while (current != NULL) {
        _terceto = (terceto*)current->dato;  // Obtener el terceto desde el nodo
        band = 0;
        
        sprintf(etiquetaComparacion, "%d", _terceto->indice);

        if(buscarPorClaveGuardaDatos(&pilaCiclos, &etiquetaComparacion, sizeof(etiquetaComparacion), compararEtiq) >= 0 ){
                fprintf(fileASM, "ETIQUETA_%s:\n", etiquetaComparacion);
        
                eliminarDesordPorClave(&pilaCiclos, &etiquetaComparacion, sizeof(etiquetaComparacion), compararEtiq);
                band = 1;
        }

        if (strcmp(_terceto->operando, "+") == 0) {     //SUMA
                eliminarUltimo(&pilaASM, &operadorDer, sizeof(operadorDer)); //leo der
                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq)); //leo izq

                printf("DER: %s     IZQ: %s\n", operadorDer, operadorIzq);

                if(strcmp(operadorIzq, "@@@") != 0){
                        //cargo a st(1) = izq
                        strcpy(dato.indice, operadorIzq);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                        fprintf(fileASM, "fld %s\n", dato.variable);
                        printf("IZQ ENCONTRADO %s\n", dato.variable);
                }

                if(strcmp(operadorDer, "@@@") != 0) {
                        //cargo a st(0) = der
                        strcpy(dato.indice, operadorDer);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);
                        fprintf(fileASM, "fld %s\n", dato.variable);
                        printf("DER ENCONTRADO %s\n", dato.variable);
                }

                fprintf(fileASM, "fadd\n\n");
                insertarListaAlFinal(&pilaASM, "@@@", sizeof("@@@"));
        }
        else if (strcmp(_terceto->operando, "-") == 0) {        //RESTA
                eliminarUltimo(&pilaASM, &operadorDer, sizeof(operadorDer)); //leo der
                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq)); //leo izq

                if(strcmp(operadorIzq, "@@@") != 0){
                        //cargo a st(1) = izq
                        strcpy(dato.indice, operadorIzq);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                        fprintf(fileASM, "fld %s\n", dato.variable);
                }

                if(strcmp(operadorDer, "@@@") != 0) {
                        //cargo a st(0) = der
                        strcpy(dato.indice, operadorDer);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);
                        fprintf(fileASM, "fld %s\n", dato.variable);
                }

                fprintf(fileASM, "fsub\n\n");
                insertarListaAlFinal(&pilaASM, "@@@", sizeof("@@@"));
        } 
        else if (strcmp(_terceto->operando, "*") == 0) {
                eliminarUltimo(&pilaASM, &operadorDer, sizeof(operadorDer)); //leo der
                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq)); //leo izq

                if(strcmp(operadorIzq, "@@@") != 0){
                        //cargo a st(1) = izq
                        strcpy(dato.indice, operadorIzq);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                        fprintf(fileASM, "fld %s\n", dato.variable);
                }

                if(strcmp(operadorDer, "@@@") != 0) {
                        //cargo a st(0) = der
                        strcpy(dato.indice, operadorDer);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);
                        fprintf(fileASM, "fld %s\n", dato.variable);
                }

                fprintf(fileASM, "fmul\n\n");
                insertarListaAlFinal(&pilaASM, "@@@", sizeof("@@@"));

        } 
        else if (strcmp(_terceto->operando, "/") == 0) {
                eliminarUltimo(&pilaASM, &operadorDer, sizeof(operadorDer)); //leo der
                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq)); //leo izq

                if(strcmp(operadorIzq, "@@@") != 0){
                        //cargo a st(1) = izq
                        strcpy(dato.indice, operadorIzq);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                        fprintf(fileASM, "fld %s\n", dato.variable);
                }

                if(strcmp(operadorDer, "@@@") != 0) {
                        //cargo a st(0) = der
                        strcpy(dato.indice, operadorDer);
                        buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);
                        fprintf(fileASM, "fld %s\n", dato.variable);
                }

                fprintf(fileASM, "fdiv\n\n");
                insertarListaAlFinal(&pilaASM, "@@@", sizeof("@@@"));
                
        } 
        else if (strcmp(_terceto->operando, ":=") == 0) {       //ASIGNACION
                strcpy(dato.indice, _terceto->operadorDer);
                int result = buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
        
                if (result >= 0) {                      //si existe en tabla de simbolos (cadena o en binarycount) se asigna directo
                        //es cad o bin
                                fprintf(fileASM, "MOV SI, OFFSET %s\n", dato.variable);

                                strcpy(dato.indice, _terceto->operadorIzq);
                                buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 

                                fprintf(fileASM, "MOV DI, OFFSET %s\n", dato.variable);
                                fprintf(fileASM, "CALL COPIAR\n\n");

                } else {
                        eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq));

                        if(strcmp(operadorIzq, "@@@") == 0) {                           //asigno expresion
                                fprintf(fileASM, "fstp %s\n\n", _terceto->operadorIzq);
                        } else {                                                        //asigno varible normal
                                strcpy(dato.indice, operadorIzq);
                                buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                                fprintf(fileASM, "fld %s\n", dato.variable);

                                fprintf(fileASM, "fstp %s\n\n", _terceto->operadorIzq);
                        }
                }

        } 
        else if (strcmp(_terceto->operando, "LEER") == 0) {
                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq));
                strcpy(dato.indice, operadorIzq);
                buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);

                if(strncmp(dato.variable, "s_", 2) == 0 || strncmp(dato.variable, "bin_", 4) == 0){ //id strings
                        fprintf(fileASM, "getString %s\n", dato.variable);
                        fprintf(fileASM, "newLine\n\n");
                } else { //float
                        fprintf(fileASM, "GetFloat %s\n", dato.variable);
                        fprintf(fileASM, "newLine\n\n");
                }                
        } 
        else if (strcmp(_terceto->operando, "ESCRIBIR") == 0) {
                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq));
                strcpy(dato.indice, operadorIzq);
                buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);

                if(strncmp(dato.variable, "s_", 2) == 0 || strncmp(dato.variable, "_cte_cad_", 9) == 0 || strncmp(dato.variable, "bin_", 4) == 0 ){ //strings o bin
                        fprintf(fileASM, "displayString %s\n", dato.variable);
                        fprintf(fileASM, "newLine\n\n");
                } else { //float
                        fprintf(fileASM, "DisplayFloat %s, 2\n", dato.variable);
                        fprintf(fileASM, "newLine\n\n");
                }
        } 
        else if (strcmp(_terceto->operando, "CMP") == 0) {
                if(strcmp(_terceto->operadorDer, "es_binario") == 0){
                        eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq));

                        //ver que hacems ==> es bin
                } else {
                        strcpy(dato.indice, _terceto->operadorIzq); //ver si son ids
                        int result = buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices);  //si son ids estan
                        if (result < 0) { //si no estan ==> son indices y tengo que desapilar
                                eliminarUltimo(&pilaASM, &operadorDer, sizeof(operadorDer));
                                eliminarUltimo(&pilaASM, &operadorIzq, sizeof(operadorIzq));

                                strcpy(dato.indice, operadorIzq);
                                buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                                fprintf(fileASM, "fld %s\n", dato.variable);

                                strcpy(dato.indice, operadorDer);
                                buscarPorClaveGuardaDatos(&ListaVariables, &dato, sizeof(dato), compararIndices); 
                                fprintf(fileASM, "fld %s\n", dato.variable);
                        } else { //estan en el CMP
                                fprintf(fileASM, "fld %s\n", _terceto->operadorIzq);
                                fprintf(fileASM, "fstp %s\n", _terceto->operadorDer);
                        }  
                }

                fprintf(fileASM, "fxch\n");
                fprintf(fileASM, "fcom\n");
                fprintf(fileASM, "fstsw ax\n");
                fprintf(fileASM, "sahf\n");
                fprintf(fileASM, "ffree\n");

        } 
        else if (strcmp(_terceto->operando, "BGE") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "jae ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
                
        } 
        else if (strcmp(_terceto->operando, "BGT") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "ja ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
                
        } 
        else if (strcmp(_terceto->operando, "BLE") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "jbe ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
                
        } 
        else if (strcmp(_terceto->operando, "BLT") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "jb ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
                
        } 
        else if (strcmp(_terceto->operando, "BEQ") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "je ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
        
        } 
        else if (strcmp(_terceto->operando, "BNE") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "jne ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
                
        } 
        else if (strcmp(_terceto->operando, "BI") == 0) {
                eliminar_corchetes(_terceto->operadorIzq);
                fprintf(fileASM, "jmp ETIQUETA_%s\n\n",_terceto->operadorIzq);
                insertarListaAlFinal(&pilaCiclos, &_terceto->operadorIzq, sizeof(_terceto->operadorIzq));
        } 
        else if (strncmp(_terceto->operando, "ETIQUETA", 8) == 0 && band == 0){
                eliminar_corchetes(_terceto->operadorIzq);
                sprintf(etiquetaComparacion, "%d", _terceto->indice);
                fprintf(fileASM, "ETIQUETA_%s:\n\n",etiquetaComparacion);
        }
        else {  //apilo comando
                insertarListaAlFinal(&pilaASM, _terceto->operando, sizeof(_terceto->operando));
                printf("APILO OPERANDO %s\n", _terceto->operando);
        }

        // Avanzar al siguiente nodo
        current = current->sig;
    } 

    sprintf(etiquetaComparacion, "%d", _terceto->indice + 1);
    
    if(buscarPorClaveGuardaDatos(&pilaCiclos, &etiquetaComparacion, sizeof(etiquetaComparacion), compararEtiq) >= 0 ){
        fprintf(fileASM, "ETIQUETA_%s:\n", etiquetaComparacion);

        eliminarDesordPorClave(&pilaCiclos, &etiquetaComparacion, sizeof(etiquetaComparacion), compararEtiq);
        band = 1;
        }

    fprintf(fileASM, "mov  ax, 4c00h\n");
    fprintf(fileASM, "int  21h\n");

    fprintf(fileASM, "; devuelve en BX la cantidad de caracteres que tiene un string\n");
    fprintf(fileASM, "; DS:SI apunta al string.\n");
    fprintf(fileASM, ";\n");
    fprintf(fileASM, "STRLEN PROC NEAR\n");
    fprintf(fileASM, "    mov bx,0\n");
    fprintf(fileASM, "STRL01:\n");
    fprintf(fileASM, "    cmp BYTE PTR [SI+BX],'$'\n");
    fprintf(fileASM, "    je STREND\n");
    fprintf(fileASM, "    inc BX\n");
    fprintf(fileASM, "    jmp STRL01\n");
    fprintf(fileASM, "STREND:\n");
    fprintf(fileASM, "    ret\n");
    fprintf(fileASM, "STRLEN ENDP\n\n");

    fprintf(fileASM, "; copia DS:SI a ES:DI; busca la cantidad de caracteres\n");
    fprintf(fileASM, ";\n");
    fprintf(fileASM, "COPIAR PROC NEAR\n");
    fprintf(fileASM, "    call STRLEN\n");
    fprintf(fileASM, "    cmp bx,MAXTEXTSIZE\n");
    fprintf(fileASM, "    jle COPIARSIZEOK\n");
    fprintf(fileASM, "    mov bx,MAXTEXTSIZE\n");
    fprintf(fileASM, "COPIARSIZEOK:\n");
    fprintf(fileASM, "    mov cx,bx\n");
    fprintf(fileASM, "    cld\n");
    fprintf(fileASM, "    rep movsb\n");
    fprintf(fileASM, "    mov al,'$'\n");
    fprintf(fileASM, "    mov BYTE PTR [DI],al\n");
    fprintf(fileASM, "    ret\n");
    fprintf(fileASM, "COPIAR ENDP\n\n");

    fprintf(fileASM, "END START\n");


    fclose(fileASM);
    printf("El archivo %s ha sido generado.\n", nombre_archivo_asm);
}

int compararIndices(const void *e1, const void *e2) {
    const datoAsm *d1 = (const datoAsm *)e1;
    const datoAsm *d2 = (const datoAsm *)e2;

    // Comparar por índice
    return strcmp(d1->indice, d2->indice);
}

int compararEtiq(const void* a, const void* b) {
    const char *d1 = (const char *)a;
    const char *d2 = (const char *)b;

    // Comparar por índice
    return strcmpi(d1, d2);
}

void eliminar_corchetes(char *texto) {
    int j = 0;
    for (int i = 0; i < strlen(texto); i++) {
        if (texto[i] != '[' && texto[i] != ']') {
            texto[j++] = texto[i];
        }
    }
    texto[j] = '\0';  // Termina la nueva cadena sin corchetes
}

