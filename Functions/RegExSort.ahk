;========================================================================
; 
; Function:     RegExSort
; Description:  Sorts an input list based on RegEx needle and matching order
; Online Ref.:  http://www.autohotkey.com/forum/topic51924.html#315809
;
; Last Update:  27/Apr/2010 15:00
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
;========================================================================
;
; p_InputList, p_RegExNeedle [, p_Order, p_OptString, p_Din, p_Dout]
;
; + Required parameters:
; - p_InputList      Input variable (see input remarks below)
; - p_RegExNeedle    RegEx to match for each item delimited by p_Din
;
; + Optional parameters:
; - p_Order          See remarks below (default: blank)
; - p_OptString      See remarks below (default: blank)
; - p_Din            Input delimiter (default: `r`n)
; - p_Dout           Output delimiter (single character, default: `n)
;
; The p_Order parameter defines the order of precedence for the
; matching subpatterns to be sorted. Should be a CSV string of
; numbers. Specifying "R" instead will use all matching subpatterns
; in reverse. When blank (default), will sort the entire RegEx match.
;
; The p_OptString parameter specifies additional options for the Sort
; command. Use the p_Dout parameter instead of the "D" option. Also,
; do not use the "\" option (see input remarks below).
;
; Regarding p_InputList, it should not containg the "\" character,
; since the presence of such character would cause the Sort command
; to misbehave. As a workaround, replace any occurrences of it with
; a dummy uncommon character before calling this function and replace
; it back afterwards.
;
; The function returns a sorted list delimited by p_Dout.
;
; Although passing a blank string to the required parameter p_RegExNeedle
; should not be intended, it is known that calling the function this way
; will cause the first item of the input list to become the last one.
;
;========================================================================

RegExSort( p_InputList , p_RegExNeedle , p_Order="" , p_OptString="" , p_Din="`r`n" , p_Dout="`n" )
{
  l_PrivChar1 := Asc(0xF024) , l_PrivChar2 := Asc(0xF025)
  Loop, Parse, p_InputList, %p_Din%
  {
    If ( !RegExMatch( A_LoopField , p_RegExNeedle , l_Output ) || ErrorLevel )
      Return
    If ( p_Order <> ( l_Matched := "" ) )
    {
      If InStr( p_Order , "R" )
        While ( l_Output%A_Index% <> "" )
          l_Matched := l_Output%A_Index% l_Matched
      Else
        Loop, Parse, p_Order, `,
          l_Matched .= l_Output%A_LoopField%
    }
    Else
      l_Matched := l_Output
    If ( l_Matched <> "" )
      l_FinalStr .= A_LoopField l_PrivChar1 "\" l_Matched l_PrivChar2 p_Dout
  }
  Sort, l_FinalStr, \ %p_OptString% D%p_Dout%
  Return RegExReplace( l_FinalStr , l_PrivChar1 ".*?" l_PrivChar2 )
}