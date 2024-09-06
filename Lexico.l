%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

FILE  *yyin;
int yylval;
char *yyltext;

int yyerror(void);

%}

%option noyywrap  
%option yylineno 
DIGITO			[0-9]
LETRA			[a-zA-Z]

CTE_ENTERA      -?{DIGITO}+
CTE_REAL        -?({DIGITO}*\.{DIGITO}+|{DIGITO}+\.{DIGITO}*)
CTE_CADENA      \"[^\"]*\"
CTE_BINARIA     "0b"(0|1)+
ID			    {LETRA}({LETRA}|{DIGITO})*

INI_COMENTARIO  "*-"
FIN_COMENTARIO  "-*"
OP_ASIG   		":="
OP_SUM          "+"
OP_RES          "-"
OP_MUL          "*"
OP_DIV          "/"
PAR_A			"("
PAR_C			")"
LLAVE_A         "{"
LLAVE_C         "}"
CORCHETE_A      "["
CORCHETE_C      "]"
COMA            ","
PUNTO           "."
DOS_PUNTOS      ":"
COMP_MAYOR      ">"
COMP_MENOR      "<"
COMP_MENORIGUAL "<="
COMP_MAYORIGUAL ">="
COMP_IGUAL      "=="
COMP_DISTINTO   "!="

%%

\*-[^\*]*\*-.*  { 
                    printf("\nERROR LEXICO: No se admiten comentarios anidados: %s\n", yytext);
                    exit(1);
                }   

"*-".*"-*"        { printf("\nComentario: %s\n", yytext); }

                    
"binaryCount"   {printf("\nBinaryCount: %s\n", yytext);return BINARYCOUNT;}
"triangulo"     {printf("\nTriangulo: %s\n", yytext);return TRIANGULO;}
"mientras"      {printf("\nMientras: %s\n", yytext);return MIENTRAS;}
"sino"          {printf("\nSino: %s\n", yytext);return SINO;}
"si"            {printf("\nSi: %s\n", yytext);return SI;}
"escribir"      {printf("\nEscribir: %s\n", yytext);return ESCRIBIR;}
"leer"          {printf("\nLeer: %s\n", yytext);return LEER;}
"Float"         {printf("\nFloat: %s\n", yytext);return FLOAT;}
"Int"           {printf("\nInt: %s\n", yytext);return INT;}
"String"        {printf("\nString: %s\n", yytext);return STRING;}
"AND"           {printf("\nAnd: %s\n", yytext);return AND;}
"OR"            {printf("\nOr: %s\n", yytext);return OR;}
"NOT"           {printf("\nNot: %s\n", yytext);return NOT;}
"init"          {printf("\nInit: %s\n", yytext);return INIT;}


{ID}            {printf("\nIdentificador: %s\n", yytext);return ID;}
{OP_ASIG}       {printf("\nAsignacion: %s\n", yytext);return OP_ASIG;}
{OP_SUM}        {printf("\nSuma: %s\n", yytext);return OP_SUM;}
{OP_MUL}        {printf("\nMultiplicacion: %s\n", yytext);return OP_MUL;}
{OP_RES}        {printf("\nResta: %s\n", yytext);return OP_RES;}
{OP_DIV}        {printf("\nDivision: %s\n", yytext);return OP_DIV;}
{PAR_A}         {printf("\nParentesisAbre: %s\n", yytext);return PAR_A;}
{PAR_C}         {printf("\nParentesisCierra: %s\n", yytext);return PAR_C;}
{LLAVE_A}       {printf("\nLlaveAbre: %s\n", yytext);return LLAVE_A;}
{LLAVE_C}       {printf("\nLlaveCierra: %s\n", yytext);return LLAVE_C;}
{CORCHETE_A}    {printf("\nCorcheteAbre: %s\n", yytext);return CORCHETE_A;}
{CORCHETE_C}    {printf("\nCorcheteCierra: %s\n", yytext);return CORCHETE_C;}
{COMA}          {printf("\nComa: %s\n", yytext);return COMA;}      
{PUNTO}         {printf("\nPunto: %s\n", yytext);return PUNTO;} 
{DOS_PUNTOS}    {printf("\nDosPuntos: %s\n", yytext);return DOS_PUNTOS;}
COMP_MENORIGUAL {printf("\nMenorIgual: %s\n", yytext);return COMP_MENORIGUAL;}
COMP_MAYORIGUAL {printf("\nMayorIgual: %s\n", yytext);return COMP_MAYORIGUAL;}
COMP_IGUAL      {printf("\nIgual: %s\n", yytext);return COMP_IGUAL;}      
COMP_DISTINTO   {printf("\nDistinto: %s\n", yytext);return COMP_DISTINTO;}   
{COMP_MAYOR}    {printf("\nMayor: %s\n", yytext);return COMP_MAYOR;} 
{COMP_MENOR}    {printf("\nMenor: %s\n", yytext);return COMP_MENOR;}

{CTE_BINARIA}   {printf("\nConstanteBinaria: %s\n", yytext);return CTE_BINARIA;}
{CTE_ENTERA}    {
                    long valor = strtol(yytext, NULL, 10); 
                    if (valor < -32768 || valor > 65535)
                    {
                        printf("\nERROR LEXICO: Constante %s fuera de rango para un Int de 16 bits.\n", yytext);
                        exit(1);
                    }
                    printf("\nConstanteEntera: %s\n", yytext);
                    return CTE_ENTERA;
                }
{CTE_REAL}      {     
                    double valor = strtod(yytext, NULL); 
                    if (valor < -3.402823e+38 || valor > 3.402823e+38) 
                    {         
                        printf("\nConstante %f fuera de rango para un Float de 32 bits.\n", yytext);  
                        exit(1);   
                    }    
                    printf("ConstanteReal: %f\n", valor); 
                    return CTE_REAL; 
                }
{CTE_CADENA}    {     
                    if (strlen(yytext) - 2 > 40) 
                    {          
                        printf("\nString %s excede los 40 caracteres permitidos.\n", yytext);     
                    }       
                    printf("\nConstanteCadena: %s\n", yytext);   
                    return CTE_CADENA; 
                }

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			    { printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}
