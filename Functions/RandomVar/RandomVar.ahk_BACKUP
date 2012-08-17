;========================================================================
; 
; Function:     RandomVar
; Description:  Returns a random content (with optional type)
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?t=47104
;
; Last Update:  25/August/2009 01:30
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
;========================================================================
;
; p_MinLength, p_MaxLength [, p_Type, p_MinAsc, p_MaxAsc]
;
; + Required parameters:
; - p_MinLength      Minimum length for returned content
; - p_MaxLength      Maximum length for returned content
;
; + Optional parameters:
; - p_Type           Content type (see remarks below)
; - p_MinAsc         Minimum ASCII for content chars
; - p_MaxAsc         Maximum ASCII for content chars
;
; Valid types are listed here: www.autohotkey.com/docs/commands/IfIs.htm
; Types "float" and "time" are not supported, though.
; Anything different from a valid type will be discarded.
; Default type is "" (blank), which does not filter any randomized char.
;
; Following special characters can be used anywhere inside type string:
; '!' - use "if var is NOT type" condition (works only with a valid type)
; '@' - avoid character repetition in returned string (case insensitive)
; '#' - avoid character repetition in returned string (case sensitive)
;
; Note: '@' and '#' will work despite of type validity!
;
; Default ASCII ranges from 32 to 126. Remember: 32 is space!
;
;========================================================================

RandomVar(p_MinLength,p_MaxLength,p_Type="",p_MinAsc=32,p_MaxAsc=126)
{

; Old method, via RegExReplace - slower and harder to understand
; p_Type := RegExReplace(RegExReplace(RegExReplace(p_Type,"!","",l_Neg),"#","@",l_Cse),"@","",l_Rep)

; New method, via StringReplace - better in performance and readability
  StringReplace,p_Type,p_Type,!,,All
  l_Neg := !ErrorLevel
  StringReplace,p_Type,p_Type,#,@,All
  l_Cse := !ErrorLevel
  StringReplace,p_Type,p_Type,@,,All
  l_Rep := !ErrorLevel

  Random, l_Aux, %p_MinLength%, %p_MaxLength%
  Loop, %l_Aux%
  {
    Loop
    {
      Random, l_Aux, %p_MinAsc%, %p_MaxAsc%
      l_Aux := Chr(l_Aux)
      If ( !l_Rep ) OR ( l_Rep AND !InStr(l_Output,l_Aux,l_Cse) )
      {
        If p_Type not in integer,number,digit,xdigit,alpha,upper,lower,alnum,space
          break
        Else
          If l_Neg
          {
            If l_Aux is not %p_Type%
              break
          }
          Else
            If l_Aux is %p_Type%
              break
      }
    }
    l_Output .= l_Aux
  }
  return l_Output

}