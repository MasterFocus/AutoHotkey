;========================================================================
; 
; Functions:    Dec2Roman & Roman2Dec
; Description:  Functions to perform convertions between roman and decimal
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?p=354957#354957
;
; Last Update:  05/Jun/2010 18:00
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Algorithm:    Check the forum thread for the original algorithm
;
;========================================================================
;
; + Required parameters:
; - D2R: p_Number       A decimal positive integer
; - R2D: p_RomanStr     A correctly formatted roman number
;
; + Optional parameters:
; - p_AllowNegative     Boolean, allow negative input (default: false)
;
; If the input is invalid, Dec2Roman returns 0 and Roman2Dec returns a
; blank string. Closed brackets are used to represent letters that are
; supposed to have a bar above it. 1000 is represented by "M", not "[I]".
;
;========================================================================

Dec2Roman(p_Number,p_AllowNegative=false)
{
  If p_Number is not integer
    Return 0
  If (p_Number=0 OR (p_Number<0 AND !p_AllowNegative))
    Return 0
  p_Number := p_Number<0 ? (Abs(p_Number),l_Signal:="-") : p_Number
  static st_Romans := "[M] [C][M] [D] [C][D] [C] [X][C] [L] [X][L] [X] M[X] [V] M[V] M CM D CD C XC L XL X IX V IV I"
  ,st_[M]:=1000000,st_[C][M]:=900000,st_[D]:=500000,st_[C][D]:=400000,st_[C]:=100000,st_[X][C]:=90000,st_[L]:=50000
  ,st_[X][L]:=40000,st_[X]:=10000,st_M[X]:=9000,st_[V]:=5000,st_M[V]:=4000,st_M:=1000,st_CM:=900,st_D:=500,st_CD:=400
  ,st_C:=100,st_XC:=90,st_L:=50,st_XL:=40,st_X:=10,st_IX:=9,st_V:=5,st_IV:=4,st_I:=1
  Loop Parse, st_Romans, %A_Space%
    While ( p_Number >= st_%A_LoopField% )
      l_String .= A_LoopField , p_Number -= st_%A_LoopField%
  Return l_Signal l_String
}

;---------------------------------------------------------------

Roman2Dec(p_RomanStr,p_AllowNegative=false)
{
  static st_Romans := "[M] [C][M] [D] [C][D] [C] [X][C] [L] [X][L] [X] M[X] [V] M[V] M CM D CD C XC L XL X IX V IV I"
  ,st_[M]:=1000000,st_[C][M]:=900000,st_[D]:=500000,st_[C][D]:=400000,st_[C]:=100000,st_[X][C]:=90000,st_[L]:=50000
  ,st_[X][L]:=40000,st_[X]:=10000,st_M[X]:=9000,st_[V]:=5000,st_M[V]:=4000,st_M:=1000,st_CM:=900,st_D:=500,st_CD:=400
  ,st_C:=100,st_XC:=90,st_L:=50,st_XL:=40,st_X:=10,st_IX:=9,st_V:=5,st_IV:=4,st_I:=1
  StringReplace, l_Needle, st_Romans, [, \[, All
  If ( !RegExMatch( p_RomanStr , "^(-?)(" l_Needle ")+$" , l_Match ) || ErrorLevel
       || ( ( l_Match1 = "-" ) AND !p_AllowNegative ) )
    Return 0
  StringReplace, l_Match, l_Match, %l_Match1%, , All
  l_Previous := l_Match2
  While ( l_Match <> "" )
  {
    StringRight, l_Removed, l_Match, 1
    StringTrimRight, l_Match, l_Match, 1
    If ( l_Removed = "]" )
    {
      StringRight, l_Match2, l_Match, 2
      StringTrimRight, l_Match, l_Match, 2
      l_Removed := l_Match2 l_Removed
    }
    If ( st_%l_Removed% < st_%l_Previous% )
    {
      l_Match2 := l_Removed l_Previous
      If ( st_%l_Previous% - st_%l_Removed% <> st_%l_Match2% )
        Return 0
      l_Sum -= ( st_%l_Removed% )
    }
    Else
    {
      l_Sum += ( st_%l_Removed% )
      l_Previous := l_Removed
    }
  }
  Return l_Match1 l_Sum
}