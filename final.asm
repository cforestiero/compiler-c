.MODEL LARGE
.386
.STACK 200h

.DATA
_cte_1		dd		1.0
_cte_Se_cumple_la_condicion.		db		"Se cumple la condicion.",'$', 3 dup (?)
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
mov  ax, 4c00h
int  21h
END
