.MODEL LARGE
.386
.STACK 200h

.DATA
_cte_-1		dd		-1.0
_cte_-3		dd		-3.0
_cte_-32768		dd		-32768.0
_cte_0.5		dd		0.5
_cte_0		dd		0.0
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
@resultado		db 256 dup (?)
_cte_cad_Equilatero		db		"Equilatero",'$', 3 dup (?)
_cte_cad_Escaleno		db		"Escaleno",'$', 3 dup (?)
_cte_cad_Esta_cadena_tiene_exacto:_40_caracteres.		db		"Esta cadena tiene exacto: 40 caracteres.",'$', 3 dup (?)
_cte_cad_Hola		db		"Hola",'$', 3 dup (?)
_cte_cad_Isosceles		db		"Isosceles",'$', 3 dup (?)
_cte_cad_No_se_cumple_la_condicion.		db		"No se cumple la condicion.",'$', 3 dup (?)
_cte_cad_Ok.		db		"Ok.",'$', 3 dup (?)
_cte_cad_Se_cumple_la_condicion.		db		"Se cumple la condicion.",'$', 3 dup (?)
_cte_cad_Soy_una_cadena		db		"Soy una cadena",'$', 3 dup (?)
float1		dd		?
float2		dd		?
float3		dd		?
int1		dd		?
int2		dd		?
_cte_cad_int2_es_mas_grande_que_int1		db		"int2 es mas grande que int1",'$', 3 dup (?)
int3		dd		?
int4		dd		?
_cte_cad_int4_es_menor_que_int5		db		"int4 es menor que int5",'$', 3 dup (?)
int5		dd		?
string1		db 256 dup (?)
string2		db 256 dup (?)

.CODE
mov  AX, @data
mov  DS, AX
mov  es, ax

fld _cte_1
fstp int1

fld _cte_1.5
fstp float1

fld _cte_0.5
fstp float2

fld _cte_cad_Soy_una_cadena
fstp string1

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

fld _cte_cad_Esta_cadena_tiene_exacto:_40_caracteres.
fstp string1

lea dx, string2
mov byte ptr [dx], 149
mov ah, 0Ah
int 21h

mov dx, OFFSET string1
mov ah, 09h
int 21h
newline 1

mov dx, OFFSET _cte_cad_Hola
mov ah, 09h
int 21h
newline 1

fld int1
fld int2
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[56]

fld int3
fld int4
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[56]

mov dx, OFFSET _cte_cad_Se_cumple_la_condicion.
mov ah, 09h
int 21h
newline 1

jmp ETIQUETA_[58]

ETIQUETA_[56]:
mov dx, OFFSET _cte_cad_No_se_cumple_la_condicion.
mov ah, 09h
int 21h
newline 1

ETIQUETA_[58]:
fld int2
fld int3
fxch
fcom
fstsw ax
sahf
ffree
ja ETIQUETA_[66]

fld int4
fld int1
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[68]

ETIQUETA_[66]:
mov dx, OFFSET _cte_cad_Ok.
mov ah, 09h
int 21h
newline 1

ETIQUETA_[68]:
fld int4
fld int5
fxch
fcom
fstsw ax
sahf
ffree
ja ETIQUETA_[80]

mov dx, OFFSET _cte_cad_int4_es_menor_que_int5
mov ah, 09h
int 21h
newline 1

fld int4
fld _cte_1
fadd

fstp int4

jmp ETIQUETA_[68]

ETIQUETA_[80]:
fld int1
fld int2
fxch
fcom
fstsw ax
sahf
ffree
ja ETIQUETA_[98]

mov dx, OFFSET _cte_cad_int2_es_mas_grande_que_int1
mov ah, 09h
int 21h
newline 1

ETIQUETA_[87]:

fld int1
fld int3
fxch
fcom
fstsw ax
sahf
ffree
jbe ETIQUETA_[97]

fld int1
fld _cte_1
fadd

fstp int1

jmp ETIQUETA_[87]

ETIQUETA_[97]:
jmp ETIQUETA_[80]

ETIQUETA_[98]:
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
jne ETIQUETA_[112]

fld @lado2
fstp @lado3

fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[112]

fld _cte_cad_Equilatero
fstp @resultado

jmp ETIQUETA_[121]

ETIQUETA_[112]:
fld @lado1
fstp @lado2

fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_[118]

fld @lado1
fstp @lado3

fxch
fcom
fstsw ax
sahf
ffree
je ETIQUETA_[118]

fld @lado2
fstp @lado3

fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[120]

ETIQUETA_[118]:
fld _cte_cad_Isosceles
fstp @resultado

jmp ETIQUETA_[121]

ETIQUETA_[120]:
fld _cte_cad_Escaleno
fstp @resultado

ETIQUETA_[121]:
fld @resultado
fstp string2

fld _cte_0
fstp @contBinarios

fld _cte_0
fld _cte_1
fadd

fstp @contBinarios

fld _cte_1
fld int1
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[130]

fld int1
fadd

fstp @contBinarios

ETIQUETA_[130]:
fld int1
fld int4
fxch
fcom
fstsw ax
sahf
ffree
jne ETIQUETA_[135]

fld int4
fadd

fstp @contBinarios

ETIQUETA_[135]:
fld int4
fadd

fstp @contBinarios

fstp int3

mov  ax, 4c00h
int  21h
END
