include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40


.DATA
_cte_-1		dd		-1.0
_cte_-3		dd		-3.0
_cte_-32768		dd		-32768.0
_cte_0.5		dd		0.5
_cte_0		dd		0.0
_cte_bin_0b10		db		0b10
_cte_bin_0b10101100		db		0b10101100
_cte_bin_0b110		db		0b110
_cte_1		dd		1.0
_cte_1.5		dd		1.5
_cte_2		dd		2.0
_cte_3		dd		3.0
_cte_4		dd		4.0
_cte_5		dd		5.0
_cte_65535		dd		65535.0
@contBinarios		dd		?
@lado1		dd		?
@lado2		dd		?
@lado3		dd		?
s_@resultado		db MAXTEXTSIZE dup (?), '$'
bin_Binarioxd		dd		?
_cte_cad_Equilatero		db		"Equilatero",'$', 10 dup (?)
_cte_cad_Escaleno		db		"Escaleno",'$', 8 dup (?)
_cte_cad_Esta_cadena_tiene_exacto:_40_caracteres.		db		"Esta cadena tiene exacto: 40 caracteres.",'$', 40 dup (?)
_cte_cad_Hola		db		"Hola",'$', 4 dup (?)
_cte_cad_Isosceles		db		"Isosceles",'$', 9 dup (?)
_cte_cad_No_se_cumple_la_condicion.		db		"No se cumple la condicion.",'$', 26 dup (?)
_cte_cad_Ok.		db		"Ok.",'$', 3 dup (?)
_cte_cad_Se_cumple_la_condicion.		db		"Se cumple la condicion.",'$', 23 dup (?)
_cte_cad_Soy_una_cadena		db		"Soy una cadena",'$', 14 dup (?)
float1		dd		?
float2		dd		?
float3		dd		?
int1		dd		?
int2		dd		?
_cte_cad_int2_es_mas_grande_que_int1		db		"int2 es mas grande que int1",'$', 27 dup (?)
int3		dd		?
int4		dd		?
_cte_cad_int4_es_menor_que_int5		db		"int4 es menor que int5",'$', 22 dup (?)
int5		dd		?
s_string1		db MAXTEXTSIZE dup (?), '$'
s_string2		db MAXTEXTSIZE dup (?), '$'

.CODE

START:

mov  AX, @data
mov  DS, AX
mov  es, ax

fld _cte_bin_0b10
fstp bin_Binarioxd

fld _cte_1
fstp int1

fld _cte_1.5
fstp float1

fld _cte_0.5
fstp float2

MOV SI, OFFSET _cte_cad_Soy_una_cadena
MOV DI, OFFSET s_string1
CALL COPIAR

fld _cte_-32768
fstp int2

fld _cte_65535
fstp int3

fld _cte_2
fld _cte_4
fadd

fstp int1

fld int1
fld _cte_1
fsub

fstp int2

fld _cte_-1
fld _cte_-3
fsub

fstp int3

fld int3
fld _cte_-1
fmul

fstp int4

fld _cte_2
fld _cte_3
fmul

fld _cte_1
fadd

fstp int5

fld float1
fld float2
fdiv

fstp float3

MOV SI, OFFSET _cte_cad_Esta_cadena_tiene_exacto:_40_caracteres.
MOV DI, OFFSET s_string1
CALL COPIAR

getString s_string2
newLine

displayString s_string1
newLine

displayString _cte_cad_Hola
newLine

fld int1
fld int2
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[57]

fld int3
fld int4
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[57]

displayString _cte_cad_Se_cumple_la_condicion.
newLine

jmp ETIQUETA_[59]

ETIQUETA_[57]:
displayString _cte_cad_No_se_cumple_la_condicion.
newLine

ETIQUETA_[59]:
fld int2
fld int3
fxch
fcom
fstsw ax
sahf
ffree
ja ETIQUETA_[67]

fld int4
fld int1
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[69]

ETIQUETA_[67]:
displayString _cte_cad_Ok.
newLine

ETIQUETA_[69]:
fld int4
fld int5
fxch
fcom
fstsw ax
sahf
ffree
ja ETIQUETA_[81]

displayString _cte_cad_int4_es_menor_que_int5
newLine

fld int4
fld _cte_1
fadd

fstp int4

jmp ETIQUETA_[69]

ETIQUETA_[81]:
fld int1
fld int2
fxch
fcom
fstsw ax
sahf
ffree
ja ETIQUETA_[99]

displayString _cte_cad_int2_es_mas_grande_que_int1
newLine

ETIQUETA_[88]:

fld int1
fld int3
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[98]

fld int1
fld _cte_1
fadd

fstp int1

jmp ETIQUETA_[88]

ETIQUETA_[98]:
jmp ETIQUETA_[81]

ETIQUETA_[99]:
fld _cte_5
fstp @lado1

fld _cte_1
fld _cte_1
fadd

fstp @lado2

fld float1
fstp @lado3

fld @lado1
fstp @lado2
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[113]

fld @lado2
fstp @lado3
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[113]

MOV SI, OFFSET _cte_cad_Equilatero
MOV DI, OFFSET s_@resultado
CALL COPIAR

jmp ETIQUETA_[122]

ETIQUETA_[113]:
fld @lado1
fstp @lado2
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_[119]

fld @lado1
fstp @lado3
fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_[119]

fld @lado2
fstp @lado3
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[121]

ETIQUETA_[119]:
MOV SI, OFFSET _cte_cad_Isosceles
MOV DI, OFFSET s_@resultado
CALL COPIAR

jmp ETIQUETA_[122]

ETIQUETA_[121]:
MOV SI, OFFSET _cte_cad_Escaleno
MOV DI, OFFSET s_@resultado
CALL COPIAR

ETIQUETA_[122]:
fld s_@resultado
fstp s_string2

fld _cte_0
fstp @contBinarios

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

fld @contBinarios
fstp int3

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
