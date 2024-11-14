include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40


.DATA
_cte_cad_1		db		" ",'$', 1 dup (?)
_cte_2		dd		2.0
_cte_3		dd		3.0
_cte_6		dd		6.0
@lado1		dd		?
@lado2		dd		?
@lado3		dd		?
s_@resultado		db MAXTEXTSIZE dup (?), '$'
_cte_cad_2		db		"El triangulo es:",'$', 16 dup (?)
_cte_cad_3		db		"Equilatero",'$', 10 dup (?)
_cte_cad_4		db		"Escaleno",'$', 8 dup (?)
_cte_cad_5		db		"Hola!",'$', 5 dup (?)
_cte_cad_6		db		"Isosceles",'$', 9 dup (?)
bin_bin1		dd		?
float1		dd		?
float2		dd		?
float3		dd		?
int1		dd		?
int2		dd		?
int3		dd		?
int4		dd		?
int5		dd		?
s_string1		db MAXTEXTSIZE dup (?), '$'
s_string2		db MAXTEXTSIZE dup (?), '$'
suma		dd		?

.CODE

START:

mov  AX, @data
mov  DS, AX
mov  es, ax

displayString _cte_cad_5
newLine

fld _cte_6
fstp int3

fld _cte_3
fld _cte_3
fadd

fstp @lado1

fld _cte_2
fstp @lado2

fld int3
fstp @lado3

fld @lado1
fstp @lado2
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_19

fld @lado2
fstp @lado3
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_19

MOV SI, OFFSET _cte_cad_3
MOV DI, OFFSET s_@resultado
CALL COPIAR

jmp ETIQUETA_28

ETIQUETA_19:
fld @lado1
fstp @lado2
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_25

fld @lado1
fstp @lado3
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_25

fld @lado2
fstp @lado3
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_27

ETIQUETA_25:
MOV SI, OFFSET _cte_cad_6
MOV DI, OFFSET s_@resultado
CALL COPIAR

jmp ETIQUETA_28

ETIQUETA_27:
MOV SI, OFFSET _cte_cad_4
MOV DI, OFFSET s_@resultado
CALL COPIAR

ETIQUETA_28:
MOV SI, OFFSET s_@resultado
MOV DI, OFFSET s_string2
CALL COPIAR

displayString _cte_cad_2
newLine

displayString s_string2
newLine

displayString _cte_cad_1
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
