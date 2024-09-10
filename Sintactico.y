%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "Lista.h"
#include "symbol_table.h"

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();

char* nombre_archivo = "symbol-table.txt";

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

%left '+''-'
%left '*''/'
%right MENOS_UNARIO

%%

programa:
        init bloque {printf("                El analizador sintactico reconoce a: <Programa> --> <Init> <Bloque>\n\n");
                        guardarTablaDeSimbolos(nombre_archivo);}
        ;

bloque:
        bloque sentencia {printf("                El analizador sintactico reconoce a: <Bloque> --> <Bloque> <Sentencia>\n\n");}
        | sentencia {printf("                El analizador sintactico reconoce: <Bloque> --> <Sentencia>\n\n");}
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
        asignacion {printf("                El analizador sintactico reconoce: <Sentencia> --> <asignacion>\n\n");}
        | iteracion {printf("                El analizador sintactico reconoce: <Sentencia> --> <iteracion>\n\n");}
        | seleccion {printf("                El analizador sintactico reconoce: <Sentencia> --> <seleccion>\n\n");}                     
        | escritura {printf("                El analizador sintactico reconoce: <Sentencia> --> <escritura>\n\n");}
        | lectura {printf("                El analizador sintactico reconoce: <Sentencia> --> <lectura>\n\n");}
        ;

asignacion:
        ID OP_ASIG expresion {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <Expresion>\n\n");}
        | ID OP_ASIG funcion_triangulo {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <funcion_triangulo>\n");}
        | ID OP_ASIG funcion_binaryCount {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG <funcion_binaryCount>\n");}
        | ID OP_ASIG CTE_CADENA {printf("                El analizador sintactico reconoce: <Asignacion> --> ID OP_ASIG CTE_CADENA\n\n");}
        ;

seleccion:
        SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C SINO LLAVE_A bloque LLAVE_C {printf("                El analizador sintactico reconoce: <Seleccion> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C SINO LLAVE_A <Bloque> LLAVE_C\n\n");}
        | SI PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C {printf("                El analizador sintactico reconoce: <Seleccion> --> SI PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C\n\n");}
        ;

condicion:
        comparacion {printf("                El analizador sintactico reconoce: <Condicion> --> <Comparacion>\n\n");}
        | comparacion AND comparacion {printf("                El analizador sintactico reconoce: <Condicion> --> <Comparacion> AND <Comparacion>\n\n");}
        | comparacion OR comparacion {printf("                El analizador sintactico reconoce: <Condicion> --> <Comparacion> OR <Comparacion>\n\n");}
        | NOT comparacion {printf("                El analizador sintactico reconoce: <Condicion> --> NOT <Comparacion>\n\n");}
        ;

comparacion:
        expresion comparador expresion {printf("                El analizador sintactico reconoce: <Comparacion> --> <Expresion> <Comparador> <Expresion>\n\n");}
        ;

comparador:
        COMP_MAYOR {printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MAYOR\n\n");}
        | COMP_MENOR {printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MENOR\n\n");}
        | COMP_MAYORIGUAL {printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MAYORIGUAL\n\n");}
        | COMP_MENORIGUAL {printf("                El analizador sintactico reconoce: <Comparador> --> COMP_MENORIGUAL\n\n");}
        | COMP_IGUAL {printf("                El analizador sintactico reconoce: <Comparador> --> COMP_IGUAL\n\n");}
        | COMP_DISTINTO {printf("                El analizador sintactico reconoce: <Comparador> --> COMP_DISTINTO\n\n");}
        ; 

iteracion:
        MIENTRAS PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C {printf("                El analizador sintactico reconoce: <Iteracion> --> MIENTRAS PAR_A <Condicion> PAR_C LLAVE_A <Bloque> LLAVE_C \n\n");}
        ;

escritura:
        ESCRIBIR PAR_A salida PAR_C {printf("                El analizador sintactico reconoce: <Escritura> --> ESCRIBIR PAR_A <Salida> PAR_C\n\n");}
        ;

salida:
        ID {printf("                El analizador sintactico reconoce: <Salida> --> ID\n\n");}
        | CTE_CADENA {printf("                El analizador sintactico reconoce: <Salida> --> CTE_CADENA\n\n");}
        | CTE_ENTERA {printf("                El analizador sintactico reconoce: <Salida> --> CTE_ENTERA\n\n");}
        | CTE_REAL {printf("                El analizador sintactico reconoce: <Salida> --> CTE_REAL\n\n");}
        ;

lectura:
        LEER PAR_A entrada PAR_C {printf("                El analizador sintactico reconoce: <Lectura> --> LEER PAR_A <Entrada> PAR_C\n\n");}
        ;

entrada:
        ID {printf("                El analizador sintactico reconoce: <Entrada> --> ID\n\n");}
        ;

expresion:
      termino {printf("                El analizador sintactico reconoce: <Expresion> --> <Termino>\n\n");}
    | expresion OP_SUM termino {printf("                El analizador sintactico reconoce: <Expresion> --> <Expresion> OP_SUM <Termino>\n\n");}
    | expresion OP_RES termino {printf("                El analizador sintactico reconoce: <Expresion> --> <Expresion> OP_RES <Termino>\n\n");}
    ;

termino: 
       factor {printf("                El analizador sintactico reconoce: <Termino> --> <Factor>\n\n");}
       |termino OP_MUL factor {printf("                El analizador sintactico reconoce: <Termino> --> <Termino> OP_MUL <Factor>\n\n");}
       |termino OP_DIV factor {printf("                El analizador sintactico reconoce: <Termino> --> <Termino> OP_DIV <Factor>\n\n");}
       ;

factor: 
      ID {printf("                El analizador sintactico reconoce: <Factor> --> ID\n\n");}
      | CTE_ENTERA {printf("                El analizador sintactico reconoce: <Factor> --> CTE_ENTERA\n\n");}
      | CTE_REAL {printf("                El analizador sintactico reconoce: <Factor> --> CTE_REAL\n\n");}
      | PAR_A expresion PAR_C {printf("                El analizador sintactico reconoce: <Factor> --> PAR_A <Expresion> PAR_C\n\n");}
      |OP_RES PAR_A expresion PAR_C %prec MENOS_UNARIO {printf("                El analizador sintactico reconoce: <Factor> --> -(<Expresion>)\n\n");}
      |OP_RES ID %prec MENOS_UNARIO {printf("                El analizador sintactico reconoce: <Factor> --> - ID\n\n");}
      ;

funcion_triangulo:
      TRIANGULO PAR_A lista_parametros PAR_C {printf("                El analizador sintactico reconoce: <Funcion_triangulo> --> TRIANGULO PAR_A <Lista_parametros> PAR_C\n\n");}
      ;

lista_parametros:
       expresion COMA expresion COMA expresion {printf("                El analizador sintactico reconoce: <Lista_parametros> --> <Expresion> COMA <Expresion> COMA <Expresion>\n\n");}
      ;

funcion_binaryCount:
      BINARYCOUNT PAR_A CORCHETE_A lista CORCHETE_C PAR_C {printf("                El analizador sintactico reconoce: <Funcion_binaryCount> --> BINARYCOUNT PAR_A CORCHETE_A <Lista> CORCHETE_C PAR_C\n\n");}
      ;

lista:
      elemento {printf("                El analizador sintactico reconoce: <Lista> --> <Elemento>\n\n");}
      | lista COMA elemento {printf("                El analizador sintactico reconoce: <Lista> --> <Lista> COMA <Elemento>\n\n");}
      ;

elemento:
      ID {printf("                El analizador sintactico reconoce: <Elemento> --> ID\n\n");}
      | CTE_ENTERA {printf("                El analizador sintactico reconoce: <Elemento> --> CTE_ENTERA\n\n");}
      | CTE_REAL {printf("                El analizador sintactico reconoce: <Elemento> --> CTE_REAL\n\n");}
      | CTE_BINARIA {printf("                El analizador sintactico reconoce: <Elemento> --> CTE_BINARIA\n\n");}
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

