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

CTE_ENTERA      {DIGITO}+
CTE_REAL        {DIGITO}*\.{DIGITO}*
CTE_CADENA      \"([^\"\\\\]|\\\\.)*\"
ID			    {LETRA}({LETRA}|{DIGITO})*
COMENTARIO      \*-(?:[^*-]|\*[^-]|-[^*])*-\*

OP_ASIG   		[":="]
OP_SUM          ["+"]
OP_MUL          ["*"]
OP_RES          ["-"]
OP_DIV          ["/"]
PAR_A			["("]
PAR_C			[")"]
LLAVE_A         ["{"]
LLAVE_C         ["}"]
COMA            [","]
PUNTO           ["."]
DOS_PUNTOS      [":"]
COMP_MAYOR      [">"]
COMP_MENOR      ["<"]
COMP_MENORIGUAL ["<="]
COMP_MAYORIGUAL [">="]
COMP_IGUAL      ["=="]
COMP_DISTINTO   ["!="]

%%

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

{CTE_ENTERA}    {
                long valor = strtol(yytext, NULL, 10); 
                if (valor < -32768 || valor > 65535) {
                    yyerror("ERROR LEXICO: Constante %s fuera de rango para un int de 16 bits\n", yytext);
                }
                printf("\nConstanteEntera: %s\n", yytext);
                return CTE_ENTERA;
}
{CTE_REAL}      {     
                    double valor = strtod(yytext, NULL); 
                    if (valor < -3.402823e+38 || valor > 3.402823e+38) 
                    {         
                        yyerror("Constante float fuera de rango para un float de 32 bits");     
                    }    
                        printf("Float válido: %f\n", valor); 
                        return CTE_REAL; }
{CTE_CADENA}    {     
                    if (strlen(yytext) - 2 > 40) 
                    {          
                        yyerror("String excede los 40 caracteres permitidos");     
                    } 
                    else {         
                        printf("String válido: %s\n", yytext);     
                    }     
                    return CTE_CADENA; }
{ID}			{printf("\nIdentificador: %s\n", yytext);return ID;}
{OP_ASIG}		{printf("\nAsignacion: %s\n", yytext);return OP_ASIG;}
{OP_SUM}		{printf("\nSuma: %s\n", yytext);return OP_SUM;}
{OP_MUL}		{printf("\nMultiplicacion: %s\n", yytext);return OP_MUL;}
{OP_RES}		{printf("\nResta: %s\n", yytext);return OP_RES;}
{OP_DIV}		{printf("\nDivision: %s\n", yytext);return OP_DIV;}
{PAR_A}			{printf("\nParentesisAbre: %s\n", yytext);return PAR_A;}
{PAR_C}			{printf("\nParentesisCierra: %s\n", yytext);return PAR_C;}
{LLAVE_A}       {printf("\nLlaveAbre: %s\n", yytext);return LLAVE_A;}
{LLAVE_C}       {printf("\nLlaveCierra: %s\n", yytext);return LLAVE_C;}
{COMA}          {printf("\nComa: %s\n", yytext);return COMA;}      
{PUNTO}         {printf("\nPunto: %s\n", yytext);return PUNTO;} 
{DOS_PUNTOS}    {printf("\nDosPuntos: %s\n", yytext);return DOS_PUNTOS;}
COMP_MENORIGUAL {printf("\nMenorIgual: %s\n", yytext);return COMP_MENORIGUAL;}
COMP_MAYORIGUAL {printf("\nMayorIgual: %s\n", yytext);return COMP_MAYORIGUAL;}
COMP_IGUAL      {printf("\nIgual: %s\n", yytext);return COMP_IGUAL;}      
COMP_DISTINTO   {printf("\nDistinto: %s\n", yytext);return COMP_DISTINTO;}   
{COMP_MAYOR}    {printf("\nMayor: %s\n", yytext);return COMP_MAYOR;} 
{COMP_MENOR}    {printf("\nMenor: %s\n", yytext);return COMP_MENOR;}
{COMENTARIO}    {printf("\nComentario: %s\n", yytext);}
"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			    { yyerror("Caracter no reconocido"); }


void yyerror(const char *mensajeError)
{     
    fprintf(stderr, "ERROR: %s en la línea %d\n", mensajeError, yylineno);     
    
    exit(1); 
}