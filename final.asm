.MODEL LARGE
.386
.STACK 200h

.DATA
_cte_-1		dd		-1.0
_cte_-3		dd		-3.0
_cte_-32768		dd		-32768.0
_cte_0.5		dd		0.5
_cte_1		dd		1.0
_cte_1.5		dd		1.5
_cte_2		dd		2.0
_cte_3		dd		3.0
_cte_4		dd		4.0
_cte_65535		dd		65535.0
_cte_cad_Esta_cadena_tiene_exacto:_40_caracteres.		db		"Esta cadena tiene exacto: 40 caracteres.",'$', 3 dup (?)
_cte_cad_Hola		db		"Hola",'$', 3 dup (?)
_cte_cad_Soy_una_cadena		db		"Soy una cadena",'$', 3 dup (?)
float1		dd		?
float2		dd		?
float3		dd		?
int1		dd		?
int2		dd		?
int3		dd		?
int4		dd		?
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

fld _cte_cad_Soy_una_cadena
fstp int2

fld _cte_cad_Soy_una_cadena
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

mov  ax, 4c00h
int  21h
END
