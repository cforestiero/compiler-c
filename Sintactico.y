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
        init bloque {printf("           El analizador sintactico reconoce a: <Programa> --> <Init> <Bloque>\n\n");}
        ;

bloque:
        bloque sentencia {printf("              El analizador sintactico reconoce a: <Bloque> --> <Bloque> <Sentencia>\n\n");}
        | sentencia {printf("           El analizador sintactico reconoce: <Bloque> --> <Sentencia>\n\n");}
        ;

init:
        INIT LLAVE_A bloque_declaracion LLAVE_C {printf("                El analizador sintactico reconoce: <Init> --> INIT LLAVE_A <Bloque_declaracion> LLAVE_C\n\n");}
        ;

bloque_declaracion:
        bloque_declaracion declaracion {printf("                El analizador sintactico reconoce: <Bloque_declaracion> --> <Bloque_declaracion> <Declaracion> es \n\n");}
        | declaracion {printf("                El analizador sintactico reconoce: <Bloque_declaracion> --> <Declaracion>\n\n");}
        ;

declaracion:
        lista_de_variables DOS_PUNTOS tipo_de_dato {printf("                El analizador sintactico reconoce: <Declaracion> --> <Lista_de_variables> DOS_PUNTOS <Tipo_de_dato>\n\n");}
        ;

lista_de_variables:
        lista_de_variables COMA ID {printf("                El analizador sintactico reconoce: <Lista_de_variables> --> <Lista_de_variables> COMA ID\n\n");}
        | ID {printf("                El analizador sintactico reconoce: <Lista_de_variables> --> ID\n\n");}
        ;

tipo_de_dato:
        INT {printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> INT\n\n");}
        | FLOAT {printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> FLOAT\n\n");}
        | STRING {printf("                El analizador sintactico reconoce: <Tipo_de_dato> --> STRING\n\n");}
        ;

sentencia:
        asignacion {printf("                El analizador sintactico reconoce: <Sentencia> --> OP_ASIG\n\n");}
        | iteracion {printf("                El analizador sintactico reconoce: <Sentencia> --> MIENTRAS\n\n");}
        | seleccion {printf("                El analizador sintactico reconoce: <Sentencia> --> SI\n\n");}                     
        | escritura {printf("                El analizador sintactico reconoce: <Sentencia> --> ESCRIBIR\n\n");}
        | lectura {printf("                El analizador sintactico reconoce: <Sentencia> --> LEER\n\n");}
        ;

asignacion:
        ID OP_ASIG expresion {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <Expresion>\n\n");}
        | ID OP_ASIG funcion_triangulo {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG TRIANGULO\n");}
        | ID OP_ASIG funcion_binaryCount {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG BINARYCOUNT\n");}
        ;

seleccion:
        SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C SINO LLAVE_A bloque LLAVE_C {printf("                El analizador sintactico reconoce: <Seleccion> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C SINO LLAVE_A <Bloque> LLAVE_C\n\n");}
        | SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C {printf("                El analizador sintactico reconoce: <Seleccion> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C\n\n");}
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

