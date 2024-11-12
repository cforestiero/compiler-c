include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40


.DATA
_cte_1		dd		1.0
_cte_2		dd		2.0
_cte_cad_Hola		db		"Hola",'$', 4 dup (?)
_cte_cad_Ingrese_un_texto		db		"Ingrese un texto",'$', 16 dup (?)
_cte_cad_PROBANDO		db		"PROBANDO",'$', 8 dup (?)
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

.CODE

START:

mov  AX, @data
mov  DS, AX
mov  es, ax

fld _cte_1
fstp int1

fld int1
fld _cte_2
fadd

fstp int2

DisplayFloat int2, 2
newLine

MOV SI, OFFSET _cte_cad_PROBANDO
MOV DI, OFFSET s_string1
CALL COPIAR

displayString _cte_cad_Ingrese_un_texto
newLine

getString s_string2
newLine

displayString s_string2
newLine

displayString s_string1
newLine

displayString _cte_cad_Hola
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
