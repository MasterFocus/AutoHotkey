;========================================================================
; 
; Function:     GetControlsInfo
; Description:  Retrieves name, HWND, position, width and height
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?t=44928
;
; Last Update:  11/August/2009 03:20
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Thanks to:    SKAN for original initial code on request topic
;               http://www.autohotkey.com/forum/viewtopic.php?t=44904
;
;========================================================================
;
; [p_WinTitle, p_WinText, p_ExcludeTitle, p_ExcludeText]
;
; All parameters are optional. Usage is same as WinExist function.
;
; The function returns a list containing information about all controls
; of the given matching window. Information provided for each control:
; Name, HWND, X and Y position, Width and Height
;
;========================================================================

GetControlsInfo(p_WinTitle="",p_WinText="",p_ExcludeTitle="",p_ExcludeText="")
{
  If ( ( p_WinTitle . p_WinText . p_ExcludeTitle . p_ExcludeText ) = "" )
    p_WinTitle := "A"
  l_ahkID := "ahk_id " WinExist(p_WinTitle,p_WinText,p_ExcludeTitle,p_ExcludeText)
  WinGet, l_CList, ControlList, %ahkID%
  Loop, Parse, l_CList, `n
  {
    ControlGetPos, l_cX, l_cY, l_cW, l_cH, %A_LoopField%, %l_ahkID%
    ControlGet, l_cHwnd, Hwnd,, %A_LoopField%, %l_ahkID%
    l_CInfo .= A_LoopField
    Loop % 30-StrLen(A_LoopField)
      l_CInfo .= "  "
    l_CInfo .= "`t" l_cHwnd
    Loop % 9-StrLen(l_cHwnd)
      l_CInfo .= "  "
    l_CInfo .= "`tx" l_cX " y" l_cY
    Loop % 16-StrLen(l_cX)-StrLen(l_cY)
      l_CInfo .= " "
    l_CInfo .= "`tw" l_cW " h" l_cH "`n"
  }
  Return l_CInfo
}