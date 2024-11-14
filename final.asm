include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40


.DATA
_cte_cad_1		db		" ",'$', 1 dup (?)
_cte_0		dd		0.0
_cte_bin_0b1001		db		"0b1001",'$', MAXTEXTSIZE dup (?)
_cte_bin_0b10101100		db		"0b10101100",'$', MAXTEXTSIZE dup (?)
_cte_bin_0b110		db		"0b110",'$', MAXTEXTSIZE dup (?)
_cte_1		dd		1.0
_cte_100		dd		100.0
_cte_15		dd		15.0
_cte_15_0		dd		15.0
_cte_150		dd		150.0
_cte_2		dd		2.0
_cte_25		dd		25.0
_cte_3		dd		3.0
_cte_50		dd		50.0
_cte_6		dd		6.0
_cte_70_7		dd		70.7
@contBinarios		dd		?
@lado1		dd		?
@lado2		dd		?
@lado3		dd		?
s_@resultado		db MAXTEXTSIZE dup (?), '$'
_cte_cad_2		db		"El numero ingresado NO es > 0 y < 50",'$', 36 dup (?)
_cte_cad_3		db		"El numero ingresado es > 0 y < 50",'$', 33 dup (?)
_cte_cad_4		db		"El resultado de la suma es:",'$', 27 dup (?)
_cte_cad_5		db		"El string ingresado es:",'$', 23 dup (?)
_cte_cad_6		db		"El triangulo es:",'$', 16 dup (?)
_cte_cad_7		db		"Equilatero",'$', 10 dup (?)
_cte_cad_8		db		"Escaleno",'$', 8 dup (?)
_cte_cad_9		db		"Estas probando el proyecto del grupo 14",'$', 39 dup (?)
_cte_cad_10		db		"Hola!",'$', 5 dup (?)
_cte_cad_11		db		"Ingresar 3 ints para sumarlos:",'$', 30 dup (?)
_cte_cad_12		db		"Ingrese un float:",'$', 17 dup (?)
_cte_cad_13		db		"Ingrese un int:",'$', 15 dup (?)
_cte_cad_14		db		"Ingrese un numero entero",'$', 24 dup (?)
_cte_cad_15		db		"Ingrese un string:",'$', 18 dup (?)
_cte_cad_16		db		"Isosceles",'$', 9 dup (?)
_cte_cad_17		db		"La cantidad de numeros binarios es:",'$', 35 dup (?)
_cte_cad_18		db		"La expresion da como resultado:",'$', 31 dup (?)
_cte_cad_19		db		"Su float es menor a 15.0 o mayor a 70.7",'$', 39 dup (?)
_cte_cad_20		db		"While anidado",'$', 13 dup (?)
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

displayString _cte_cad_10
newLine

displayString _cte_cad_9
newLine

displayString _cte_cad_15
newLine

getString s_string1
newLine

displayString _cte_cad_5
newLine

displayString s_string1
newLine

displayString _cte_cad_1
newLine

displayString _cte_cad_12
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
jb ETIQUETA_29

fld float1
fld float2
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_31

ETIQUETA_29:
displayString _cte_cad_19
newLine

ETIQUETA_31:
displayString _cte_cad_1
newLine

displayString _cte_cad_13
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
jbe ETIQUETA_48

fld int1
fld _cte_50
fxch
fcom
fstsw ax
sahf
ffree
jae ETIQUETA_48

displayString _cte_cad_3
newLine

jmp ETIQUETA_50

ETIQUETA_48:
displayString _cte_cad_2
newLine

ETIQUETA_50:
displayString _cte_cad_1
newLine

displayString _cte_cad_11
newLine

fld _cte_3
fstp int2

fld _cte_0
fstp suma

ETIQUETA_58:

fld int2
fld _cte_0
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_76

displayString _cte_cad_14
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

jmp ETIQUETA_58

ETIQUETA_76:
displayString _cte_cad_4
newLine

DisplayFloat suma, 2
newLine

displayString _cte_cad_1
newLine

displayString _cte_cad_20
newLine

fld _cte_1
fstp int1

fld _cte_3
fstp int2

ETIQUETA_88:

fld int1
fld _cte_3
fxch
fcom
fstsw ax
sahf
ffree
jae ETIQUETA_112

ETIQUETA_93:

fld int2
fld _cte_0
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_105

DisplayFloat int2, 2
newLine

fld int2
fld _cte_1
fsub

fstp int2

jmp ETIQUETA_93

ETIQUETA_105:
DisplayFloat int1, 2
newLine

fld int1
fld _cte_1
fadd

fstp int1

jmp ETIQUETA_88

ETIQUETA_112:
fld _cte_100
fstp int4

fld _cte_25
fld _cte_2
fmul

fld _cte_150
fxch
fadd

fld int4
fsub

fstp int5

fld _cte_3
fld _cte_2
fadd

fld int5
fxch
fdiv

fstp int5

displayString _cte_cad_1
newLine

displayString _cte_cad_18
newLine

DisplayFloat int5, 2
newLine

displayString _cte_cad_1
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
fld @lado2
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_152

fld @lado2
fld @lado3
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_152

MOV SI, OFFSET _cte_cad_7
MOV DI, OFFSET s_@resultado
CALL COPIAR

jmp ETIQUETA_161

ETIQUETA_152:
fld @lado1
fld @lado2
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_158

fld @lado1
fld @lado3
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_158

fld @lado2
fld @lado3
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_160

ETIQUETA_158:
MOV SI, OFFSET _cte_cad_16
MOV DI, OFFSET s_@resultado
CALL COPIAR

jmp ETIQUETA_161

ETIQUETA_160:
MOV SI, OFFSET _cte_cad_8
MOV DI, OFFSET s_@resultado
CALL COPIAR

ETIQUETA_161:
MOV SI, OFFSET s_@resultado
MOV DI, OFFSET s_string2
CALL COPIAR

displayString _cte_cad_6
newLine

displayString s_string2
newLine

displayString _cte_cad_1
newLine

MOV SI, OFFSET _cte_bin_0b1001
MOV DI, OFFSET bin_bin1
CALL COPIAR

MOV SI, OFFSET _cte_0
MOV DI, OFFSET @contBinarios
CALL COPIAR

fld @contBinarios
fld _cte_1
fadd

fstp @contBinarios

fld @contBinarios
fld _cte_1
fadd

fstp @contBinarios

fld @contBinarios
fld _cte_1
fadd

fstp @contBinarios

MOV SI, OFFSET @contBinarios
MOV DI, OFFSET int3
CALL COPIAR

displayString _cte_cad_17
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
