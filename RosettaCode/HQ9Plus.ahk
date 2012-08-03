; ====== ====== ====== ====== ====== ======
; Task:
; 	Execute HQ9+ @ RosettaCode
; Language:
; 	AutoHotkey
; Links:
; 	http://rosettacode.org/wiki/Execute_HQ9%2B#AutoHotkey
; 	http://www.autohotkey.com/forum/viewtopic.php?p=356268#356268
; Date:
; 	19/MAY/2010
; Author:
; 	Antonio aka MasterFocus - http://tiny.cc/iTunis
; ====== ====== ====== ====== ====== ======

testCode := "hq9+HqQ+Qq"

MsgBox % RunHQ9Plus(testCode)

;---------------------------------

RunHQ9Plus(input)
{
  Loop, Parse, input
    If ( A_LoopField = "+" )
      acc++
    Else If ( A_LoopField = "H" )
      output .= "Hello, world!`n"
    Else If ( A_LoopField = "Q" )
      output .= input "`n"
    Else If ( A_LoopField = "9" )
      Loop, 99
      {
        ; following 4 lines could be only 1 long line
        output .= (99+1-A_Index) " bottles of beer on the wall`n"
        output .= (99+1-A_Index) " bottles of beer`n"
        output .= "Take one down, pass it around`n"
        output .= (99-A_Index) " bottles of beer on the wall`n`n"
      }
  Return output
}