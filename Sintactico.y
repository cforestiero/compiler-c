// Usa Lexico_ClasePractica
//Solo expresiones sin ()
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
%token COMENTARIO
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
sentencia:  	   
	asignacion {printf(" FIN\n");} ;

asignacion: 
          ID OP_AS expresion {printf("    ID = Expresion es ASIGNACION\n");}
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
      | CTE {printf("    CTE es Factor\n");}
	| PA expresion PC {printf("    Expresion entre parentesis es Factor\n");}
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

