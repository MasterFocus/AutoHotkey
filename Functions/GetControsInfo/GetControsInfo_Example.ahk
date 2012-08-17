#SingleInstance FORCE
#Include GetControlsInfo.ahk

F12::
CtrlList := GetControlsInfo()
Loop, Parse, CtrlList, `n
{
  Output .= A_LoopField "`n"
  If !Mod(A_Index,30)
  {
    MsgBox % Output "more..."
    Output := ""
  }
}
MsgBox % Output
CtrlList := ""
Output := ""
Return

^F12::Reload

^Esc::ExitApp