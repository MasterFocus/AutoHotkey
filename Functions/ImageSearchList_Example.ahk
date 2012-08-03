#Include ImageSearchList.ahk

; Make sure that CoordMode is the same for mouse and pixel
; ----------------------------------------------------------------------------
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
Return

;=============================================================================

; Use F12 to start searching for the image
; ----------------------------------------------------------------------------
F12::
  glob_List := ImageSearchList("pic.bmp",0,0,0,0,",","`n","f_MyDebug")
  ToolTip
  MsgBox, % "ImageSearchList() output:`n" glob_List
  MsgBox, % "Moving mouse to each found coordinate..."
  Loop, Parse, glob_List, `n
  {
    Click %A_LoopField% 0
    Sleep, 100
  }
  MsgBox, % "Finished!"
Return

; Example function to debug the process
; ----------------------------------------------------------------------------
f_MyDebug(p_Index,p_OutX,p_OutY,p_InitX,p_InitY,p_FinalX,p_FinalY,p_ImgStr,p_List)
{
  l_Text := "Iteration:`t" p_Index "`n"
  l_Text .= "Output Pos:`t[" f_Fill(p_OutX) "," f_Fill(p_OutY) "]`n"
  l_Text .= "Start Pos:`t[" f_Fill(p_InitX) "," f_Fill(p_InitY) "]`n"
  l_Text .= "Final Pos:`t[" f_Fill(p_FinalX) "," f_Fill(p_FinalY) "]`n"
  l_Text .= "Image String:`t" p_ImgStr "`n"
  l_Text .= "`nList of matching coordinates:`n" p_List
  ToolTip, %l_Text%
  Sleep, 250
}

; Use the Pause button to help debugging
; ----------------------------------------------------------------------------
Pause::Pause

; Use the Esc button to exit
; ----------------------------------------------------------------------------
Escape::ExitApp

; Auxiliar function
; ----------------------------------------------------------------------------
f_Fill(p_Input) {
  Return SubStr("_____",1,5-StrLen(p_Input)) p_Input
}