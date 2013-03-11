;************************************************
; Test script for Gdip_ImageSearch()
; by MasterFocus
; 09/March/2013 09:15 BRT
;************************************************

#NoEnv
ListLines, Off
SetBatchLines, -1
Process, Priority,, High

#Include GDIP.ahk
#Include Gdip_ImageSearch.ahk

OnExit, EXIT_LABEL

gdipToken := Gdip_Startup()
;;bmpHaystack := Gdip_BitmapFromScreen()
bmpHaystack := Gdip_CreateBitmapFromFile("haystack.png")
bmpNeedle := Gdip_CreateBitmapFromFile("folder.png")
ERR := Gdip_ImageSearch(bmpHaystack,bmpNeedle,LIST,COUNT)
Gdip_DisposeImage(bmpHaystack)
Gdip_DisposeImage(bmpNeedle)
Gdip_Shutdown(gdipToken)

MsgBox, % "Error: " ERR "`tCount: " COUNT "`n`n" LIST

;; following loop used for pointing to each instance of
;; the needle when the haystack is the screen
/*
CoordMode, Mouse, Screen
Loop, Parse, LIST, `n
{
    StringSplit, Coord, A_LoopField, `,
    MouseMove, %Coord1%, %Coord2%, 0
    Sleep, 200
}
*/

EXIT_LABEL: ; be really sure the script will shutdown GDIP
Gdip_Shutdown(gdipToken)
EXITAPP