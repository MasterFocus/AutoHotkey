;========================================================================
; 
; Function:     GetTuples (aka Arrange)
; Description:  Arranges a given input and returns it as N-tuples
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?t=59511
;
; Last Update:  20/Jul/2010 16:30
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Thanks to:   Laszlo, for original B2B() function
;              http://www.autohotkey.com/forum/topic17350.html
;
;========================================================================
;
; p_List [, p_Pick, p_Din, p_Dout, p_Offset, p_Count]
;
; + Required parameters:
; - p_List     Input list of elements (optionally delimited)
;
; + Optional parameters:
; - p_Pick     Number of elements for each tuple (default: 2)
; - p_Din      Input delimiter (default: blank)
; - p_Dout     Output delimiter (default: `n)
; - p_Offset   Starting offset for the output tuples (default: 0)
; - p_Count    Number of output tuples (default: 0, outputs all tuples)
;
; The function returns the given input arranged into tuples of p_Pick
; elements, which allow repetition. See http://en.wikipedia.org/wiki/Tuple
; for further information. The input is optionally delimited by p_Din.
;
;========================================================================

GetTuples(p_List,p_Pick=2,p_Din="",p_Dout="`n",p_Offset=0,p_Count=0) {
  If ( p_List = "" ) OR ( p_Pick < 1 )
    Return
  StringSplit, l_Arr, p_List, %p_Din%
  If ( p_Count > (l_TotalTuples := l_Arr0 ** p_Pick) ) OR ( p_Count = 0 )
    p_Count := l_TotalTuples - p_Offset  ,  l_TotalTuples := ""
  Loop, %p_Count% {
    Loop, % p_Pick - StrLen( l_Aux := B2B(A_Index-1+p_Offset,10,l_Arr0) )
      l_Aux := "0" l_Aux
    l_Output .= p_Dout
    Loop, Parse, l_Aux
      l_Output .= A_LoopField "|"
  }
  Loop, %l_Arr0%
    StringReplace,l_Output,l_Output,% B2B(A_Index-1,10,l_Arr0) "|",% l_Arr%A_Index%,All
  Return SubStr( l_Output , 1+StrLen(p_Dout) )
}

;------------------------------------------------------------------------

B2B(p_Num,p_iB,p_oB) { ; modified version of Laszlo's original B2B() function
  VarSetCapacity(l_R,65,0)
  l_N := DllCall("msvcrt\_strtoui64","Str",p_Num,"Uint",0,"UInt",p_iB,"CDECL Int64")
  Return l_R, DllCall("msvcrt\_i64toa","Int64",l_N,"Str",l_R,"UInt",p_oB,"CDECL")
}