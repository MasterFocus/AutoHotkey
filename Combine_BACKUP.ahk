CHANGELOG:

13/september/2012
• Fixed output concatenation when the p_Func function returned blank

29/august/2012
• Initial release

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

EXAMPLE + CODE:

; =====================================================
; By Antonio (aka MasterFocus)
; Timestamp: 29/AUG/2012 20:30
; Licensed under GNU AGPL v3
; For more information, please see:
; - http://www.autohotkey.com/community/viewtopic.php?f=2&t=59511
; (this temporary header will be modified later)
; =====================================================

List =
(
1234
a
@#
txk
)

MsgBox, % Combine(List)

EXITAPP

;------------------------------------------

Combine(p_List,p_InputD="`n",p_InputO="`r",p_InnerD="",p_InnerO=" `t",p_OutputDin="",p_OutputDout="`n",p_Offset=0,p_Count=0,p_Func="") {
  If ( p_List = "" )
    Return
  l_Total := 1, l_IsFunc := IsFunc(p_Func), p_Offset := Abs(p_Offset)
  StringSplit, l_List, p_List, %p_InputD%, %p_InputO% ; split main list
  Loop, %l_List0% {
    l_List%A_Index%Index := 1
    StringSplit, l_List%A_Index%Char, l_List%A_Index%, %p_InnerD%, %p_InnerO% ; split inner lists
    l_Total *= l_List%A_Index%Char0
  }
  If ( p_Count > l_Total ) OR ( p_Count = 0 )
    p_Count := l_Total - p_Offset
  Loop, %l_Total% {
    l_MainIndex := A_Index, l_Result := ""
    Loop, %l_List0% {
      l_Divisor := l_List%A_Index%Char0
      Loop, % l_List0 - ( l_InnerOffset := A_Index )
        l_AuxIndex := A_Index+l_InnerOffset, l_Divisor *= l_List%l_AuxIndex%Char0
	  l_AuxIndex := l_List%A_Index%Index
      l_Result .= p_OutputDin l_List%A_Index%Char%l_AuxIndex%

      l_List%A_Index%Index += !Mod(l_MainIndex,l_Total/l_Divisor)
      If ( l_List%A_Index%Index > l_List%A_Index%Char0 )
        l_List%A_Index%Index := 1

    }
    If ( l_MainIndex-1 < p_Offset )
      Continue
    l_Result := SubStr(l_Result,1+StrLen(p_OutputDin)), l_Result := l_IsFunc
      ? (((l_Dummy := %p_Func%(l_Result))<>"") ? p_OutputDout l_Dummy : "")
      : p_OutputDout l_Result, l_Output .= l_Result
    If ( --p_Count <= 0 )
      Break
  }
  Return SubStr(l_Output,1+StrLen(p_OutputDout))
}