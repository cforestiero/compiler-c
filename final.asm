.MODEL LARGE
.386
.STACK 200h
.DATA
_cte_1  dd       1
_cte_int1  dd                                                  
_cte_int2  dd                                                  
_cte_int3  dd                                                  
_cte_int4  dd                                                  
_cte_int5  dd                                                  
.CODE
mov  AX, @data
mov  DS, AX
mov  es, ax
mov  ax, 4c00h
int  21h
END
