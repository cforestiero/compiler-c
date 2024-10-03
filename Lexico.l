%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "Lista.h"
#include "symbol_table.h"

FILE  *yyin;
int yylval;
char *yyltext;
int yyerror(void);
void eliminar_comillas(char* cadena);

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
-\*[^\*]*\*-    { 
                    printf("\nERROR LEXICO: tipo de comentario no admitido: %s\n", yytext);
                }
\*-[^\*]*\*-.*  { 
                    printf("\nERROR LEXICO: tipo de comentario no admitido: %s\n", yytext);
                } 
"*-".*"-*"        { printf("El analizador lexico reconoce a: %s como Comentario\n", yytext); }
"binaryCount"   {printf("El analizador lexico reconoce a: %s como BinaryCount\n", yytext); return BINARYCOUNT;}
"triangulo"     {printf("El analizador lexico reconoce a: %s como Triangulo\n", yytext); return TRIANGULO;}
"mientras"      {printf("El analizador lexico reconoce a: %s como Mientras\n", yytext); return MIENTRAS;}
"sino"          {printf("El analizador lexico reconoce a: %s como Sino\n", yytext); return SINO;}
"si"            {printf("El analizador lexico reconoce a: %s como Si\n", yytext); return SI;}
"escribir"      {printf("El analizador lexico reconoce a: %s como Escribir\n", yytext); return ESCRIBIR;}
"leer"          {printf("El analizador lexico reconoce a: %s como Leer\n", yytext); return LEER;}
"Float"         {printf("El analizador lexico reconoce a: %s como Float\n", yytext); return FLOAT;}
"Int"           {printf("El analizador lexico reconoce a: %s como Int\n", yytext); return INT;}
"String"        {printf("El analizador lexico reconoce a: %s como String\n", yytext); return STRING;}
"AND"           {printf("El analizador lexico reconoce a: %s como And\n", yytext); return AND;}
"OR"            {printf("El analizador lexico reconoce a: %s como Or\n", yytext); return OR;}
"NOT"           {printf("El analizador lexico reconoce a: %s como Not\n", yytext); return NOT;}
"init"          {printf("El analizador lexico reconoce a: %s como Init\n", yytext); return INIT;}

{ID}            {printf("El analizador lexico reconoce a: %s como Identificador\n", yytext); 
                agregarSimbolo(yytext,"","","");
                return ID;
                }
{OP_ASIG}       {printf("El analizador lexico reconoce a: %s como Asignacion\n", yytext); return OP_ASIG;}
{OP_SUM}        {printf("El analizador lexico reconoce a: %s como Suma\n", yytext); return OP_SUM;}
{OP_MUL}        {printf("El analizador lexico reconoce a: %s como Multiplicacion\n", yytext); return OP_MUL;}
{OP_RES}        {printf("El analizador lexico reconoce a: %s como Resta\n", yytext); return OP_RES;}
{OP_DIV}        {printf("El analizador lexico reconoce a: %s como Division\n", yytext); return OP_DIV;}
{PAR_A}         {printf("El analizador lexico reconoce a: %s como Parentesis Abre\n", yytext); return PAR_A;}
{PAR_C}         {printf("El analizador lexico reconoce a: %s como Parentesis Cierra\n", yytext); return PAR_C;}
{LLAVE_A}       {printf("El analizador lexico reconoce a: %s como Llave Abre\n", yytext); return LLAVE_A;}
{LLAVE_C}       {printf("El analizador lexico reconoce a: %s como Llave Cierra\n", yytext); return LLAVE_C;}
{CORCHETE_A}    {printf("El analizador lexico reconoce a: %s como Corchete Abre\n", yytext); return CORCHETE_A;}
{CORCHETE_C}    {printf("El analizador lexico reconoce a: %s como Corchete Cierra\n", yytext); return CORCHETE_C;}
{COMA}          {printf("El analizador lexico reconoce a: %s como Coma\n", yytext); return COMA;}
{PUNTO}         {printf("El analizador lexico reconoce a: %s como Punto\n", yytext); return PUNTO;}
{DOS_PUNTOS}    {printf("El analizador lexico reconoce a: %s como Dos Puntos\n", yytext); return DOS_PUNTOS;}
{COMP_MENORIGUAL} {printf("El analizador lexico reconoce a: %s como Menor Igual\n", yytext); return COMP_MENORIGUAL;}
{COMP_MAYORIGUAL} {printf("El analizador lexico reconoce a: %s como Mayor Igual\n", yytext); return COMP_MAYORIGUAL;}
{COMP_IGUAL}      {printf("El analizador lexico reconoce a: %s como Igual\n", yytext); return COMP_IGUAL;}
{COMP_DISTINTO}   {printf("El analizador lexico reconoce a: %s como Distinto\n", yytext); return COMP_DISTINTO;}
{COMP_MAYOR}    {printf("El analizador lexico reconoce a: %s como Mayor\n", yytext); return COMP_MAYOR;}
{COMP_MENOR}    {printf("El analizador lexico reconoce a: %s como Menor\n", yytext); return COMP_MENOR;}
{CTE_BINARIA}   {
                    long valor = strtol(yytext + 2, NULL, 2);
                    int length = strlen(yytext) - 2;
                    if (length == 16 && yytext[2] == '1') {  
                        valor -= (1L << 16); 
                    }
                    if (valor < -32768 || valor > 65535) {
                        printf("\nERROR LEXICO: Constante binaria %s fuera de rango para un Int de 16 bits.\n", yytext);
                        exit(1);
                    }else{
                        printf("El analizador lexico reconoce a: %s como Constante Binaria\n", yytext); 
                        agregarSimbolo(yytext,"",yytext,"");
                        return CTE_BINARIA;
                    }
                }
{CTE_ENTERA}    {
                    long valor = strtol(yytext, NULL, 10); 
                    if (valor < -32768 || valor > 65535)
                    {
                        printf("ERROR LEXICO: Constante %s fuera de rango para un Int de 16 bits.\n", yytext);
                        exit(1);
                        
                    }else{
                        printf("El analizador lexico reconoce a: %s como Constante Entera\n", yytext);
                        agregarSimbolo(yytext,"",yytext,"");
                        return CTE_ENTERA;
                    }
                }

{CTE_REAL}      {     
                    double valor = strtod(yytext, NULL); 
                    if (valor < -3.402823e+38 || valor > 3.402823e+38) 
                    {         
                        printf("ERROR LEXICO: Constante %f fuera de rango para un Float de 32 bits.\n", valor);  
                        exit(1);
                    }else{
                        printf("El analizador lexico reconoce a: %f como Constante Real\n", valor); 
                        agregarSimbolo(yytext,"",yytext,"");
                        return CTE_REAL; 
                    }    
                }

{CTE_CADENA}    {     
                    if (strlen(yytext) - 2 > 40) 
                    {          
                        printf("ERROR LEXICO: String %s excede los 40 caracteres permitidos.\n", yytext);   
                        exit(1);  
                    }else{
                        printf("El analizador lexico reconoce a: %s como Constante Cadena\n", yytext); 
                        char longitud[10];
                        itoa(strlen(yytext)-2, longitud,10);
                        eliminar_comillas(yytext);
                        agregarSimbolo(yytext,"",yytext, longitud);  
                        return CTE_CADENA; 
                    }       
                }

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			    { printf("ERROR LEXICO: Caracter no reconocido: %s\n", yytext); exit(1);}

%%
void eliminar_comillas(char* cadena) {
    int longitud = strlen(cadena);
    if (longitud > 1 && cadena[0] == '"' && cadena[longitud - 1] == '"') {
        memmove(cadena, cadena + 1, longitud - 1);
        cadena[longitud - 2] = '\0';
    }
}
