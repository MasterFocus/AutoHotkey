; ====== ====== ====== ====== ====== ======
; Task:
; 	Repeat A String @ RosettaCode
; Language:
; 	AutoHotkey
; Link:
; 	http://rosettacode.org/wiki/Repeat_a_string#AutoHotkey
; Date:
; 	10/APR/2010
; Author:
; 	Antonio aka MasterFocus - http://tiny.cc/iTunis
; ====== ====== ====== ====== ====== ======

MsgBox % Repeat("ha",5)

;--------------------

Repeat(String,Times)
{
  Loop, %Times%
    Output .= String
  Return Output
}