/*
    WaitPixelColor.ahk
    Copyright (C) 2009 Antonio França

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
; Function:     WaitPixelColor
; Description:  Waits until pixel is a certain color (w/ optional timeout)
; URL (+info):  https://bit.ly/R7gT8a
;
; Last Update:  19/July/2009 04:30 BRT
;
; Created by MasterFocus
; - https://github.com/MasterFocus
; - http://masterfocus.ahk4.net
; - http://autohotkey.com/community/viewtopic.php?f=2&t=88198
;
;========================================================================

WaitPixelColor(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0,p_GetMode="",p_ReturnColor=0)
{
    l_Start := A_TickCount
    Loop
    {
        PixelGetColor, l_RetrievedColor, %p_PosX%, %p_PosY%, %p_GetMode%
        If ErrorLevel
        {
            If !p_ReturnColor
                Return 1
            Break
        }
        If ( l_RetrievedColor = p_DesiredColor )
        {
            If !p_ReturnColor
                Return 0
            Break
        }
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut )
        {
            If !p_ReturnColor
                Return 2
            Break
        }
    }
    Return l_RetrievedColor
}