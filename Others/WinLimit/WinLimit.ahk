/*
    WinLimit.ahk
    Copyright (C) 2010,2013 Antonio França

    This script is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This script is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this script.  If not, see <http://www.gnu.org/licenses/>.
*/

;========================================================================
; 
; Script:       WinLimit (aka XPSnap / XP Snap)
; Description:  Prevent windows from being dragged off the screen
; URL (+info):  http://autohotkey.com/community/viewtopic.php?p=405187#p405187
;
; Last Update:  11/April/2013 03:45 BRT
;
; Created by MasterFocus
; - https://github.com/MasterFocus
; - http://masterfocus.ahk4.net
; - http://autohotkey.com/community/viewtopic.php?f=2&t=88198
;
;========================================================================

CoordMode, Mouse
SetBatchLines, -1
SetWinDelay, -1
ListLines, Off
; Set the script's priority as high (not really necessary)
Process, Priority, , High

; If the Monitor Work Area may change while the script is running,
; put the following 2 lines right after the 'ConfineLabel:' line
SysGet, MWA_, MonitorWorkArea
scrW := MWA_Right-MWA_Left , scrH := MWA_Bottom-MWA_Top

Return

;-------------------------------------------------

~*$LButton::
  MouseGetPos, , , hWin
  WinGetClass, wClass, ahk_id %hWin%
  WinGet, State, MinMax, ahk_id %hWin%
  WinGetPos, winX, winY, winW, winH, ahk_id %hWin%
  ; Only if the clicked window is not maximized/minimized, and it's not the Tray area
  If (!State && (wClass!="Shell_TrayWnd")) {
    oldX := winX, oldY := winY, oldW := winW, oldH := winH
    SetTimer, ConfineLabel, 10
  }
  KeyWait, LButton
  SetTimer, ConfineLabel, Off
  Confine()
Return

;-------------------------------------------------

ConfineLabel:
  WinGetPos, winX, winY, winW, winH, ahk_id %hWin%
  ; Confine if window was not closed, and didn't retain position/dimensions...
  If (winW && winH && !((oldX=winX)&(oldY=winY)&(oldW=winW)&(oldH=winH))) {
    SetTimer, ConfineLabel, Off
    MouseGetPos, mouseX, mouseY
    Confine(1,mouseX-winX,mouseY-winY,mouseX+scrW-winW-winX,mouseY+scrH-winH-winY)
  }
  oldX := winX, oldY := winY, oldW := winW, oldH := winH
Return

;=================================================

; Following function adapted from:
; http://www.autohotkey.com/community/viewtopic.php?f=2&t=22178
Confine(C=0,X1=0,Y1=0,X2=0,Y2=0) {
  VarSetCapacity(R,16,0),NumPut(X1,&R+0),NumPut(Y1,&R+4),NumPut(X2,&R+8),NumPut(Y2,&R+12)
  Return C ? DllCall("ClipCursor",UInt,&R) : DllCall("ClipCursor")
}