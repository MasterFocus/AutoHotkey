;========================================================================
; 
; Function:     GetDriveByLabel
; Description:  Retrieves the first drive that matches the given label
; Online Ref.:  http://www.autohotkey.com/forum/topic49396.html
;
; Last Update:  29/Sep/2009 13:00
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
;========================================================================
;
; p_Label
;
; + Required parameters:
; - p_Label          The desired drive label
;
;
; The function returns the letter of the first found drive that matches
; the given label, or blank if none. Although the matching is not case
; sensitive, it must be the exact given label.
;
;========================================================================

GetDriveByLabel(p_Label)
{
  DriveGet, l_Temp, List
  Loop, Parse, l_Temp
  {
    DriveGet, l_Temp, Label, %A_LoopField%:
    If ( l_Temp = p_Label )
      Return A_LoopField
  }
}