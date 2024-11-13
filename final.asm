include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40


.DATA
_cte_0      dd      0.0
_cte_1      dd      1.0
_cte_15_0       dd      15.0
_cte_5      dd      5.0
_cte_50     dd      50.0
_cte_70_7       dd      70.7
bin_Binarioxd       dd      ?
_cte_cad_El_numero_ingresado_NO_es_>_0_y_<_50       db      "El numero ingresado NO es > 0 y < 50",'$', 36 dup (?)
_cte_cad_El_numero_ingresado_es_>_0_y_<_50      db      "El numero ingresado es > 0 y < 50",'$', 33 dup (?)
_cte_cad_El_resultado_de_la_suma_es     db      "El resultado de la suma es",'$', 26 dup (?)
_cte_cad_Estas_probando_el_proyecto_del_grupo_14        db      "Estas probando el proyecto del grupo 14",'$', 39 dup (?)
_cte_cad_Hola       db      "Hola",'$', 4 dup (?)
_cte_cad_Ingrese_un_float       db      "Ingrese un float",'$', 16 dup (?)
_cte_cad_Ingrese_un_int     db      "Ingrese un int",'$', 14 dup (?)
_cte_cad_Ingrese_un_numero_entero       db      "Ingrese un numero entero",'$', 24 dup (?)
_cte_cad_Ingrese_un_string      db      "Ingrese un string",'$', 17 dup (?)
_cte_cad_Su_float_es_menor_a_15.0_o_mayor_a_70.7_        db      "Su float es menor a 15.0 o mayor a 70.7",'$', 39 dup (?)
float1      dd      ?
float2      dd      ?
float3      dd      ?
int1        dd      ?
int2        dd      ?
int3        dd      ?
int4        dd      ?
int5        dd      ?
s_string1       db MAXTEXTSIZE dup (?), '$'
s_string2       db MAXTEXTSIZE dup (?), '$'
suma        dd      ?

.CODE

START:

mov  AX, @data
mov  DS, AX
mov  es, ax

displayString _cte_cad_Hola
newLine

displayString _cte_cad_Estas_probando_el_proyecto_del_grupo_14
newLine

displayString _cte_cad_Ingrese_un_string
newLine

getString s_string1
newLine

displayString s_string1
newLine

displayString _cte_cad_Ingrese_un_float
newLine

GetFloat float1
newLine

fld _cte_70_7
fstp float2

fld float1
fld _cte_15_0
fxch
fcom
fstsw ax
sahf
ffree
jb ETIQUETA_25

fld float1
fld float2
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_27

ETIQUETA_25:
displayString _cte_cad_Su_float_es_menor_a_15.0_o_mayor_a_70.7_
newLine

ETIQUETA_27:
displayString _cte_cad_Ingrese_un_int
newLine

GetFloat int1
newLine

fld int1
fld _cte_0
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_42

fld int1
fld _cte_50
fxch
fcom
fstsw ax
sahf
ffree
jae ETIQUETA_42

displayString _cte_cad_El_numero_ingresado_es_>_0_y_<_50
newLine

jmp ETIQUETA_44

ETIQUETA_42:
displayString _cte_cad_El_numero_ingresado_NO_es_>_0_y_<_50
newLine

ETIQUETA_44:
fld _cte_5
fstp int2

fld _cte_0
fstp suma

ETIQUETA_48:

fld int2
fld _cte_0
fxch
fcom
fstsw ax
sahf
ffree
displayString _cte_cad_Ingrese_un_numero_entero
newLine

GetFloat int3
newLine

fld suma
fld int3
fadd

fstp suma

fld int2
fld _cte_1
fsub

fstp int2

jmp ETIQUETA_48

displayString _cte_cad_El_resultado_de_la_suma_es
newLine

DisplayFloat int3, 2
newLine

mov  ax, 4c00h
int  21h
; devuelve en BX la cantidad de caracteres que tiene un string
; DS:SI apunta al string.
;
STRLEN PROC NEAR
    mov bx,0
STRL01:
    cmp BYTE PTR [SI+BX],'$'
    je STREND
    inc BX
    jmp STRL01
STREND:
    ret
STRLEN ENDP

; copia DS:SI a ES:DI; busca la cantidad de caracteres
;
COPIAR PROC NEAR
    call STRLEN
    cmp bx,MAXTEXTSIZE
    jle COPIARSIZEOK
    mov bx,MAXTEXTSIZE
COPIARSIZEOK:
    mov cx,bx
    cld
    rep movsb
    mov al,'$'
    mov BYTE PTR [DI],al
    ret
COPIAR ENDP

END START
