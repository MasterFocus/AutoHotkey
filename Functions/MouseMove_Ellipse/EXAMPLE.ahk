#NoEnv
ListLines, Off
CoordMode, Mouse, Screen
SetBatchLines, -1

#Include MouseMove_Ellipse.ahk

; Press CTRL+RButton and release both to watch the mouse movement
^RButton::
  KeyWait, RButton
  KeyWait, Control
  MouseMove_Ellipse( +50 , +50 , "S0.35 I1 R" )
  MouseMove_Ellipse( -50 , +50 , "S0.35 I1 R" )
  MouseMove_Ellipse( -50 , -50 , "S0.35 I1 R" )
  MouseMove_Ellipse( +50 , -50 , "S0.35 I1 R" )
Return

; Press CTRL+RAlt+Button and release all to watch the mouse movement
^!RButton::
  KeyWait, RButton
  KeyWait, Control
  KeyWait, Alt
  Loop, 6
    MouseMove_Ellipse( 50 , 50 , "S0.35 R I" Mod(A_Index,2) )
Return