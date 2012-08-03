;========================================================================
; 
; Template:     Checkboxes Template
; Description:  Creates a GUI with items to work with the selected ones
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?p=349695#349695
; * WARNING *   Online version (above) is a mod to close running processes
;
; Last Update:  15/Sep/2009 11:30
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
;========================================================================
;
; * HOW TO MODIFY the template:
;
; 1. Add the desired items to the variable "glob_Items"
;
; 2. Insert the desired actions where "ToolTip" is currently used
;
; These main modifiable parts contain comments started by "***"
;
;========================================================================

; Insert directives and other initial commands here
#NoEnv
SetBatchLines, -1

; Starting Y position
glob_PosY := 10

; *** Declare the desired items here
glob_Items := "item1|item2|item3|item4|item5"
glob_Items .= "|item6|item7|item8|item9"
glob_Items .= "|item10|item11|item12|item13|item14"
glob_Items .= "|item15"
glob_Items .= "|item16|item17"

; Create the GUI
Gui, +ToolWindow
Loop, Parse, glob_Items, |
{
  Gui, Add, CheckBox, x10 y%glob_PosY% vglob_Box%A_Index% Checked, %A_LoopField%
  glob_PosY += 15
}
Gui, Add, Button, w100 h50 x10 y%glob_PosY% Default, OK
Gui, Show

Return

;----------------------------------------------

; Proceed when the default button "OK" is clicked
ButtonOK:
  Gui, Submit
  Loop, Parse, glob_Items, |
  {
    If ( glob_Box%A_Index% )
    {
      ; *** Insert code to deal with the checked items here [ BEGIN ]
      ToolTip, Item '%A_LoopField%' was checked.
      Sleep, 250
      ; *** Insert code to deal with the checked items here [ END ]
    }
  }
  Gui, Show
Return

;----------------------------------------------

; Exit if the GUI is closed
GuiClose:
GuiEscape:
  ExitApp