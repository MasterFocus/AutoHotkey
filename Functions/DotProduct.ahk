; ====== ====== ====== ====== ====== ======
; Task:
; 	Dot Product @ RosettaCode
; Language:
; 	AutoHotkey
; Link:
; 	http://rosettacode.org/wiki/Dot_product#AutoHotkey
; Date:
; 	10/APR/2010
; Author:
; 	Antonio aka MasterFocus - http://tiny.cc/iTunis
; ====== ====== ====== ====== ====== ======

Vet1 := "1,3,-5"
Vet2 := "4 , -2 , -1"
MsgBox % DotProduct( Vet1 , Vet2 )

;---------------------------

DotProduct( VectorA , VectorB )
{
  Sum := 0
  StringSplit, ArrayA, VectorA, `,, %A_Space%
  StringSplit, ArrayB, VectorB, `,, %A_Space%
  If ( ArrayA0 <> ArrayB0 )
    Return ERROR
  While ( A_Index <= ArrayA0 )
    Sum += ArrayA%A_Index% * ArrayB%A_Index%
  Return Sum
}