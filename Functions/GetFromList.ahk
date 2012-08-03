;========================================================================
; 
; Function:     GetFromList
; Description:  Retrieve random or specific items from a list
; Online Ref.:  http://www.autohotkey.com/forum/topic49456.html#300019
; * WARNING *   Online version (above) is old and incomplete!
;
; Last Update:  16/Mar/2010 17:30
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
;========================================================================
;
; p_What, p_List [, p_Din, p_Dout, p_Where, p_RemDup, p_Csen]
;
; + Required parameters:
; - p_What      Number or substring (see remarks below)
; - p_List      Input list
;
; + Optional parameters:
; - p_Din       Input delimiter (default: "`r`n")
; - p_Dout      Output delimiter (default: ",")
; - p_Where     Substring matching position (see remarks below)
; - p_RemDup    Boolean, removes duplicates
; - p_Csen      Boolean, case sensitive matching
;
; If p_What is a number, the function will return the specified number
; of random items. If p_What is a substring, all items containing the
; substring will be retrieved, according to the p_Where option.
;
; + Options for p_Where substring matching (one letter only):
; - "A": items contaning the substring anywhere (default)
; - "S": items started by the substring
; - "M": items containing the substring but not started/ended by it
; - "E": items ended by the substring
;
; Specifying 0 for any optinal parameter will use its default.
;
;========================================================================

GetFromList(p_What,p_List,p_Din=0,p_Dout=0,p_Where=0,p_RemDup=0,p_Csen=0)
{
  p_Din:=(p_Din ? p_Din : "`r`n"),p_Dout:=(p_Dout ? p_Dout : ","),p_RemDup:=(p_RemDup ? "U" : ""),p_Csen:=(p_Csen ? "C" : "")
  If p_Where not in a,s,m,e
    p_Where := "a"
  If p_What is number
  {
    Sort, p_List, D%p_Din% Random %p_RemDup%
    Loop, Parse, p_List, %p_Din%, %p_Din%
    {
      res .= ( res<>"" ? p_Dout : "" ) A_LoopField
      If ( A_Index = p_What )
        Break
    }
  }
  Else
  {
    Sort, p_List, D%p_Din% %p_RemDup% %p_Csen%
    Loop, Parse, p_List, %p_Din%, %p_Din%
    {
      lenA := StrLen(A_LoopField) , lenW := StrLen(p_What)
      If ( p_Where="a" AND InStr(A_LoopField,p_What,p_Csen) ) OR ( p_Where="s" AND (SubStr(A_LoopField,1,lenW)=p_What) ) OR ( p_Where="m" AND InStr(SubStr(A_LoopField,1+lenW,lenA-1-lenW),p_What,p_Csen) ) OR ( p_Where="e" AND (SubStr(A_LoopField,1-lenW)=p_What) )
        res .= ( res<>"" ? p_Dout : "" ) A_LoopField , found := (p_Where="s")
      Else If (p_Where="s") AND found
        Break
    }
  }
  return res
}