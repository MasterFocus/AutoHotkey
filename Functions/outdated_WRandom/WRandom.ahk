;========================================================================
; 
; Function:     WRandom
; Description:  Gets a random field from a weighted set
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?t=47586
;
; Last Update:  12/August/2009 19:30
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Thanks to:    [VxE] for original code/algorithm
;               www.autohotkey.com/forum/viewtopic.php?p=287940#287940
;
;========================================================================
;
; p_FieldString [, p_Chance, p_P2D, p_D2P]
;
; + Required parameters:
; - p_FieldString    CSV string containing a decimal weight for each field
;
; + Optional parameters:
; - p_Chance         Boolean, shows chance (%) the selected field had
; - p_P2D            Boolean, shows 1% in decimal
; - p_D2P            Boolean, shows 1 (decimal) in percentage
;
; The function returns the number of the selected field.
; If any optional parameters are present, they will be concatenated to
; the returned string (CSV) in the order they are presented.
;
;========================================================================

WRandom(p_FieldString,p_Chance=false,p_P2D=false,p_D2P=false)
{
  Loop, Parse, p_FieldString, `,
    l_Tot += A_LoopField
  Random, l_Sum, 0, % l_Tot
  Loop, Parse, p_FieldString, `,
    If ( 0 >= l_Sum -= A_LoopField )
      Return A_Index ( p_Chance ? "," (100*A_LoopField)/l_Tot : "" ) ( p_P2D ? "," l_Tot/100 : "" ) ( p_D2P ? "," 100/l_Tot : "" )
}