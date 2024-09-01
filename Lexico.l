%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <stdarg.h>


FILE  *yyin;
int yylval;
char *yyltext;

void yyerror(const char *mensajeError);

%}

%option noyywrap  
%option yylineno 

DIGITO			[0-9]
LETRA			[a-zA-Z]

CTE_ENTERA      {DIGITO}+
CTE_REAL        {DIGITO}*\.{DIGITO}*
CTE_CADENA      \"([^\"\\\\]|\\\\.)*\"
ID			    {LETRA}({LETRA}|{DIGITO})*


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

"binaryCount"   {printf("\nBinaryCount: %s\n", yytext);}
"triangulo"     {printf("\nTriangulo: %s\n", yytext);}
"mientras"      {printf("\nMientras: %s\n", yytext);}
"sino"          {printf("\nSino: %s\n", yytext);}
"si"            {printf("\nSi: %s\n", yytext);}
"escribir"      {printf("\nEscribir: %s\n", yytext);}
"leer"          {printf("\nLeer: %s\n", yytext);}
"Float"         {printf("\nFloat: %s\n", yytext);}
"Int"           {printf("\nInt: %s\n", yytext);}
"String"        {printf("\nString: %s\n", yytext);}
"AND"           {printf("\nAnd: %s\n", yytext);}
"OR"            {printf("\nOr: %s\n", yytext);}
"NOT"           {printf("\nNot: %s\n", yytext);}
"init"          {printf("\nInit: %s\n", yytext);}

{CTE_ENTERA}    {
                long valor = strtol(yytext, NULL, 10); 
                if (valor < -32768 || valor > 65535) {
                    char mensaje[100];
                    sprintf(mensaje, "ERROR LEXICO: Constante %s fuera de rango para un int de 16 bits", yytext);
                    yyerror(mensaje);
                }
                printf("\nConstanteEntera: %s\n", yytext);
}
{CTE_REAL}      {     
                    double valor = strtod(yytext, NULL); 
                    if (valor < -3.402823e+38 || valor > 3.402823e+38) 
                    {         
                        yyerror("Constante float fuera de rango para un float de 32 bits");     
                    }    
                    printf("Float válido: %f\n", valor); 
}
{CTE_CADENA}    {     
                    if (strlen(yytext) - 2 > 40) 
                    {          
                        yyerror("String excede los 40 caracteres permitidos");     
                    } 
                    else {         
                        printf("String válido: %s\n", yytext);     
                    }     
}
{ID}            {printf("\nIdentificador: %s\n", yytext);}
{OP_ASIG}       {printf("\nAsignacion: %s\n", yytext);}
{OP_SUM}        {printf("\nSuma: %s\n", yytext);}
{OP_MUL}        {printf("\nMultiplicacion: %s\n", yytext);}
{OP_RES}        {printf("\nResta: %s\n", yytext);}
{OP_DIV}        {printf("\nDivision: %s\n", yytext);}
{PAR_A}         {printf("\nParentesisAbre: %s\n", yytext);}
{PAR_C}         {printf("\nParentesisCierra: %s\n", yytext);}
{LLAVE_A}       {printf("\nLlaveAbre: %s\n", yytext);}
{LLAVE_C}       {printf("\nLlaveCierra: %s\n", yytext);}
{COMA}          {printf("\nComa: %s\n", yytext);}      
{PUNTO}         {printf("\nPunto: %s\n", yytext);} 
{DOS_PUNTOS}    {printf("\nDosPuntos: %s\n", yytext);}
COMP_MENORIGUAL {printf("\nMenorIgual: %s\n", yytext);}
COMP_MAYORIGUAL {printf("\nMayorIgual: %s\n", yytext);}
COMP_IGUAL      {printf("\nIgual: %s\n", yytext);}      
COMP_DISTINTO   {printf("\nDistinto: %s\n", yytext);}   
{COMP_MAYOR}    {printf("\nMayor: %s\n", yytext);} 
{COMP_MENOR}    {printf("\nMenor: %s\n", yytext);}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			    { yyerror("Caracter no reconocido"); }

%%

int main(int argc, char *argv[])
{
    if (argc > 1) {
        if ((yyin = fopen(argv[1], "rt")) == NULL) {
            printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;  // Leer de la entrada estándar si no se proporciona archivo
        printf("Entre aca");
    }
 
    printf("Iniciando analisis lexico...\n");
    yylex();
    printf("Analisis lexico completado.\n");

    fclose(yyin);
    return 0;
}
 
void yyerror(const char *mensajeError) {     
    fprintf(stderr, "ERROR: %s en la linea %d\n", mensajeError, yylineno);     
    exit(1); 
}