.MODEL LARGE
.386
.STACK 200h

.DATA
_cte_-1		dd		-1.0
_cte_-3		dd		-3.0
_cte_-32768		dd		-32768.0
_cte_.5		dd		0.5
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
_cte_Equilatero		db		"Equilatero",'$', 3 dup (?)
_cte_Escaleno		db		"Escaleno",'$', 3 dup (?)
_cte_Esta_cadena_tiene_exacto:_40_caracteres.		db		"Esta cadena tiene exacto: 40 caracteres.",'$', 3 dup (?)
_cte_Hola		db		"Hola",'$', 3 dup (?)
_cte_Isosceles		db		"Isosceles",'$', 3 dup (?)
_cte_No_se_cumple_la_condicion.		db		"No se cumple la condicion.",'$', 3 dup (?)
_cte_Ok.		db		"Ok.",'$', 3 dup (?)
_cte_Se_cumple_la_condicion.		db		"Se cumple la condicion.",'$', 3 dup (?)
_cte_Soy_una_cadena		db		"Soy una cadena",'$', 3 dup (?)
float1		dd		?
float2		dd		?
float3		dd		?
int1		dd		?
int2		dd		?
_cte_int2_es_mas_grande_que_int1		db		"int2 es mas grande que int1",'$', 3 dup (?)
int3		dd		?
int4		dd		?
_cte_int4_es_menor_que_int5		db		"int4 es menor que int5",'$', 3 dup (?)
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
