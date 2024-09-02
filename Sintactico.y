%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();


%}

%token CTE_ENTERA
%token CTE_REAL
%token CTE_CADENA
%token CTE_BINARIA
%token ID
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


%%

programa:
        init sentencia {printf("	Init Sentencia es Programa\n");}
        | init bloque sentencia {printf("	Init Bloque Sentencia es Programa\n");}
        ;

bloque:
        bloque sentencia {printf("	Bloque Sentencia es Bloque\n");}
        | sentencia {printf("	Sentencia es Bloque\n");}
        ;

init:
        INIT LLAVE_A bloque_declaracion LLAVE_C {printf("	init { Bloque_declaracion } es Init\n");}
        ;

bloque_declaracion:
        bloque_declaracion declaracion {printf("	Bloque_declaracion Declaracion es Bloque_declaracion\n");}
        | declaracion {printf("	Declaracion es Bloque_declaracion\n");}
        ;

declaracion:
        lista_de_variables DOS_PUNTOS tipo_de_dato {printf("	Lista_de_variables : Tipo_de_dato es Declaracion\n");}
        ;

lista_de_variables:
        lista_de_variables COMA ID {printf("	Lista_de_variables , ID es Lista_de_variables\n");}
        | ID {printf("	ID es Lista_de_variables\n");}
        ;

tipo_de_dato:
        INT {printf("	Int es Tipo_de_dato\n");}
        | FLOAT {printf("	Float es Tipo_de_dato\n");}
        | STRING {printf("	String es Tipo_de_dato\n");}
        ;

sentencia:
        asignacion {printf("	Asignacion es Sentencia\n");}
        | iteracion {printf("	Iteracion es Sentencia\n");}
        | seleccion {printf("	Seleccion es Sentencia\n");}
        | escritura {printf("	Escritura es Sentencia\n");}
        | lectura {printf("	Lectura es Sentencia\n");}
        ;

asignacion:
        ID OP_ASIG expresion {printf("	ID := Expresion es Asignacion\n");}
        | ID OP_ASIG funcion_triangulo {printf("	ID := Funcion_triangulo es Asignacion\n");}
        | ID OP_ASIG funcion_binaryCount {printf("	ID := Funcion_binaryCount es Asignacion\n");}
        ;

seleccion:
        SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C SINO LLAVE_A bloque LLAVE_C {printf("	si (condicion) {bloque} sino {bloque} es Seleccion\n");}
        | SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C {printf("	si (condicion) {bloque} es Seleccion\n");}
        ;

condicion:
        comparacion {printf("	Comparacion es Condicion\n");}
        | comparacion AND comparacion {printf("	Comparacion AND Comparacion es Condicion\n");}
        | comparacion OR comparacion {printf("	Comparacion OR Comparacion es Condicion\n");}
        | NOT comparacion {printf("	NOT Comparacion es Condicion\n");}
        ;

comparacion:
        expresion comparador expresion {printf("	Expresion Comparador Expresion es Comparacion\n");}
        ;

comparador:
        COMP_MAYOR {printf("	COMP_MAYOR es Comparador\n");}
        | COMP_MENOR {printf("	COMP_MENOR es Comparador\n");}
        | COMP_MAYORIGUAL {printf("	COMP_MAYORIGUAL es Comparador\n");}
        | COMP_MENORIGUAL {printf("	COMP_MENORIGUAL es Comparador\n");}
        | COMP_IGUAL {printf("	COMP_IGUAL es Comparador\n");}
        | COMP_DISTINTO {printf("	COMP_DISTINTO es Comparador\n");}
        ; 

iteracion:
        MIENTRAS PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C {printf("	mientras (condicion) {bloque} es Iteracion\n");}
        ;

escritura:
        ESCRIBIR PAR_A salida PAR_C {printf("	escribir (salida) es Escritura\n");}
        ;

salida:
        ID {printf("	ID es Salida\n");}
        | CTE_CADENA {printf("	CTE_CADENA es Salida\n");}
        | CTE_ENTERA {printf("	CTE_ENTERA es Salida\n");}
        | CTE_REAL {printf("	CTE_REAL es Salida\n");}
        ;

lectura:
        LEER PAR_A entrada PAR_C {printf("	leer (entrada) es Lectura\n");}
        ;

entrada:
        ID {printf("	ID es Entrada\n");}
        ;

expresion:
        termino {printf("    Termino es Expresion\n");}
	      |expresion OP_SUM termino {printf("    Expresion+Termino es Expresion\n");}
	      |expresion OP_RES termino {printf("    Expresion-Termino es Expresion\n");}
	      ;

termino: 
       factor {printf("    Factor es Termino\n");}
       |termino OP_MUL factor {printf("     Termino*Factor es Termino\n");}
       |termino OP_DIV factor {printf("     Termino/Factor es Termino\n");}
       ;

factor: 
      ID {printf("    ID es Factor \n");}
      | CTE_ENTERA {printf("    CTE_ENTERA es Factor\n");}
      | CTE_REAL {printf("    CTE_REAL es Factor\n");}
	    | PAR_A expresion PAR_C {printf("    Expresion entre parentesis es Factor\n");}
     	;

funcion_triangulo:
      TRIANGULO PAR_A lista_parametros PAR_C {printf("	triangulo (Lista_parametros)es Triangulo\n");}
      ;

lista_parametros:
       expresion COMA expresion COMA expresion {printf("	Expresion, Expresion, Expresion es Lista_parametros\n");}
      ;

funcion_binaryCount:
      BINARYCOUNT PAR_A CORCHETE_A lista CORCHETE_C PAR_C {printf("	binaryCount ( [Lista] ) es BinaryCount\n");}
      ;

lista:
      elemento {printf("	Elemento es Lista\n");}
      | lista COMA elemento {printf("	Lista , Elemento es Lista\n");}
      ;

elemento:
      ID {printf("	ID es Elemento\n");}
      | CTE_ENTERA {printf("	CTE_ENTERA es Elemento\n");}
      | CTE_REAL {printf("	CTE_REAL es Elemento\n");}
      | CTE_BINARIA {printf("	CTE_BINARIA es Elemento\n");}
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
	  exit (1);
}

