;========================================================================
; 
; Function:     ClearArray
; Description:  Clears array elements (makes them become empty)
; Online Ref.:  -
;
; Last Update:  16/Mar/2010 19:00
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Thanks to:    SKAN and Titan for the VarExist function
;               http://www.autohotkey.com/forum/viewtopic.php?p=83371
;
;========================================================================
;
; p_ArrayName [, p_Start, p_End]
;
; + Required parameters:
; - p_ArrayName         Name of the array variable
;
; + Optional parameters:
; - p_Start and p_End   Determine which elements will be cleared
;
; Both p_Start and p_End are self-explanatory. If p_End is 0 (default),
; the function will start clearing all elements (from p_Start, which is
; also 0 by default) until it finds a non-existent element (which has
; never been initialized). So, if both parameters are omitted, the function
; will only attempt to clear ArrayName0. Returns 1 for no elements cleared.
;
; Plase note that:
; - Declaring a variable with an empty content will not initialise it
; - An initialised variable isn't automatically delete if it becomes empty
; ( as stated here: www.autohotkey.com/forum/viewtopic.php?p=83371#83371 )
;
; + Return values:
; - 0      Elements cleared successfully
; - 1      No elements were cleared
; - 2      At least one parameter is incorrect
;
;========================================================================

ClearArray(p_ArrayName,p_Start=0,p_End=0)
{
  local l_tmp, l_count
  If ( p_Start < 0 ) OR ( p_End < 0 ) OR ( p_End > p_Start )
    Return 2
  If !p_End
    Loop
    {
      tmp := p_ArrayName . p_Start
      If !varExist(%tl_tmp%)
        Break
      %l_tmp% := "" , l_count++ , p_Start++
    }
  Else
    Loop
    {
      %p_ArrayName%%p_Start% := "" , l_count++
      If ( p_Start = p_End )
        Break
      p_Start++
    }
  Return !l_count
}

varExist(ByRef v) {
   return &v = &n ? 0 : v = "" ? 2 : 1
}