%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "Lista.h"
#include "symbol_table.h"
#include "Tercetos.h"

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();
char* formatear(int indice);
char* formatearComparador(char* comparador);

char* nombre_archivo_tabla = "symbol-table.txt";
char* nombre_archivo_tercetos = "intermediate-code.txt";

int AsignacionInd;
int ExpresionInd;
int TerminoInd;
int FactorInd;
int PorgramaInd;
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

int contBinarios = 0;
int CondicionTipo;

int listaCreada = 0;
Lista ListaAignaciones;
Lista ListaComparaciones;
Lista ListaComparadores;
Lista ListaCondicionesTipo;
Lista ListaExpresiones;


%}

%union {
    char* s;
}

%token <s> CTE_ENTERA
%token <s> CTE_REAL
%token <s> CTE_CADENA
%token CTE_BINARIA
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
%token AND
%token OR
%token NOT
%token INIT
%type <s> tipo_de_dato
%type <s> elemento

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
                PorgramaInd = BloqueInd;
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
                char aux[sizeof(char[300])] ;
                while (!listaVacia(&ListaAignaciones)) {
                        eliminarPrimero(&ListaAignaciones, aux, sizeof(char[300]));
                        if(agregarSimbolo(aux,$3,"","") != TODO_OK) {
                                exit(1);
                        }          
                }
           
                printf("                El analizador sintactico reconoce: <Declaracion> --> <Lista_de_variables> DOS_PUNTOS <Tipo_de_dato>\n\n");}
        ;

lista_de_variables:
        lista_de_variables COMA ID {
                
                if(insertarListaOrdSinDupli(&ListaAignaciones, $3, sizeof(char[300]), compararArrojandoError) != TODO_OK){
                        exit(1);
                }
                printf("                El analizador sintactico reconoce: <Lista_de_variables> --> <Lista_de_variables> COMA ID\n\n");}
        | ID {
                if(!listaCreada){
                        
                        crearLista(&ListaAignaciones);
                        listaCreada = 1;
                }
              
                if(insertarListaOrdSinDupli(&ListaAignaciones, $1, sizeof(char[300]), compararArrojandoError) != TODO_OK){
                        exit(1);
                }

                printf("                El analizador sintactico reconoce: <Lista_de_variables> --> ID\n\n");}
        ;

tipo_de_dato:
        INT {                       
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> INT\n\n");}
        | FLOAT {
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> FLOAT\n\n");}
        | STRING { 
                printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> STRING\n\n");}
        ;

sentencia:
        asignacion {
                SentenciaInd = AsignacionInd;

                printf("                El analizador sintactico reconoce: <Sentencia> --> <asignacion>\n\n");
        }
        | iteracion {
                SentenciaInd = AsignacionInd;

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
        | iteracion {
                SentenciaInd = IteracionInd;

                printf("                El analizador sintactico reconoce: <Sentencia> --> <iteracions>\n\n");
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

                char cantBinarios[6];
                sprintf(cantBinarios, "%d", contBinarios);
                AsignacionInd = agregarTerceto(":=", $1, cantBinarios);
                contBinarios = 0;
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

        }
        comparador expresion {
                
                printf("                El analizador sintactico reconoce: <Comparacion> --> <Expresion> <Comparador> <Expresion>\n\n");
                
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
                int aux_etiqueta_while = agregarTerceto("ETIQUETA_INCIO_WHILE","_","_");
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
        }
        ;

lista_parametros:
        expresion {
                agregarTerceto(":=","@lado1",formatear(ExpresionInd));
        }
        COMA expresion {
                agregarTerceto(":=","@lado2",formatear(ExpresionInd));
        }
        COMA expresion { 
                agregarTerceto(":=","@lado3",formatear(ExpresionInd));
                printf("                El analizador sintactico reconoce: <Lista_parametros> --> <Expresion> COMA <Expresion> COMA <Expresion>\n\n");
        }
        ;

funcion_binaryCount:
        BINARYCOUNT PAR_A CORCHETE_A lista CORCHETE_C PAR_C {
                printf("                El analizador sintactico reconoce: <Funcion_binaryCount> --> BINARYCOUNT PAR_A CORCHETE_A <Lista> CORCHETE_C PAR_C\n\n");
        }
        ;

lista:
        elemento {
                //ListaInd = ElementoInd;
                printf("                El analizador sintactico reconoce: <Lista> --> <Elemento>\n\n");
        }
        | lista COMA elemento {
                //ListaInd = agregarTerceto(",", formatear(ListaInd), formatear(ElementoInd));
                printf("                El analizador sintactico reconoce: <Lista> --> <Lista> COMA <Elemento>\n\n");
        }
        ;

elemento:
        ID {
                printf("                El analizador sintactico reconoce: <Elemento> --> ID\n\n");
                //ElementoInd = agregarTerceto($1, "_", "_");
                //aca habria que validar si es binario en tabla de simbolos
        }
        | CTE_ENTERA {
                printf("                El analizador sintactico reconoce: <Elemento> --> CTE_ENTERA\n\n");
                //ElementoInd = agregarTerceto($1, "_", "_");
        }
        | CTE_REAL {
                printf("                El analizador sintactico reconoce: <Elemento> --> CTE_REAL\n\n");
                //ElementoInd = agregarTerceto($1, "_", "_");
        }
        | CTE_BINARIA {
                printf("                El analizador sintactico reconoce: <Elemento> --> CTE_BINARIA\n\n");
                //ElementoInd = agregarTerceto("CTE_BINARIA", "_", "_");
                contBinarios++;
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