
:: Generar el analizador léxico con flex
flex Lexico.l

gcc lex.yy.c -o compilador.exe


:: Pausar para ver cualquier mensaje de error
pause

:: Ejecutar el compilador con el archivo de prueba
compilador.exe prueba.txt

:: Pausar para ver lo que hace
pause

:: Limpiar los archivos generados
@echo off
del compilador.exe
del lex.yy.c

