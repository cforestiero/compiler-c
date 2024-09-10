:: Script para windowsc
flex Lexico.l
bison -dyv Sintactico.y


gcc.exe lex.yy.c y.tab.c symbol_table.c Lista.c -o compilador.exe


compilador.exe prueba1.txt

@echo off
del compilador.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause

