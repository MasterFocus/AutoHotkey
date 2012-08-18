#Include GetControlsInfo.ahk
MsgBox, F12 to get info about current window's controls`nCtrl+Esc to close the script
Return

F12::
  Gui, Destroy
  CtrlList := GetControlsInfo()
  Height := 15 , Index := 0
  Loop, Parse, CtrlList, `n
    TotalCount := A_Index
  Loop, Parse, CtrlList, `n
  {
    Gui, +ToolWindow
    Gui, Margin, 0, 0
    StringSplit, Array, A_LoopField, |
    Index++ , Y := ((Index-1)*Height)+5
    Gui, Add, Text, % "h"Height " w180 x5 y" Y, %Array1%
	Gui, Add, Text, % "h"Height " w80 x190 y" Y, %Array2%
    Gui, Add, Text, % "h"Height " w50 xp+85 y" Y, %Array3%
	Gui, Add, Text, % "h"Height " w50 xp+55 y" Y, %Array4%
    Gui, Add, Text, % "h"Height " w50 xp+55 y" Y, %Array5%
    Gui, Add, Text, % "h"Height " w50 xp+55 y" Y, %Array5%
    If !Mod(Index,40) && (TotalCount>A_Index) {
      Gui, Add, Text, % "h"Height " x5 y" (Index*Height)+5, Press ESC or close the window to show more...
      Gui, Show
      Index := 0
      Pause
    }
  }
  Gui, Show
Return

GuiEscape:
GuiClose:
  If A_IsPaused
    Pause
  Gui, Destroy
Return

^Esc::ExitApp