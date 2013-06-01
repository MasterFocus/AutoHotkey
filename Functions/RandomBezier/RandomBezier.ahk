/*
    RandomBezier.ahk
    Copyright (C) 2012 Antonio França

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
; Function:     RandomBezier
; Description:  Moves the mouse through a random Bézier path
; URL (+info):  --------------------
;
; Last Update:  24/September/2012 06:50h BRT
;
; Created by MasterFocus
; - https://github.com/MasterFocus
; - http://masterfocus.ahk4.net
; - http://autohotkey.com/community/viewtopic.php?f=2&t=88198
;
;========================================================================

RandomBezier(p_Xi,p_Yi,p_Xf,p_Yf,p_Time=200,p_R=0,p_OffT=100,p_OffB=100,p_OffL=100,p_OffR=100,p_Max=5,p_Min=3) {

   MouseGetPos, l_X0, l_Y0 ; get mouse coordinates
   If ( p_R ) { ; if relative...
      p_Xf += l_X0 , p_Yf += l_Y0 ; ...first we add the current mouse position to the final coordinates...
      l_X0 += p_Xi , l_Y0 += p_Yi ; ...and then we add the offsets to the mouse position, so we can use X0 and Y0 themselves
   }
   Else
      l_X0 := p_Xi , l_Y0 := p_Yi ; otherwise, use the correct coordinates

   ; ------
   ; THE PREVIOUS LINES are obviously not optimized. I will later change the logic used.
   ; ------

   ; Prepare to correctly add (or subtract) the top/bottom/left/right offsets
   If ( l_X0 < p_Xf ) ; compare the initial and final X
      l_SmallestX := l_X0-p_OffL , l_BiggestX := p_Xf+p_OffR
   Else
      l_SmallestX := p_Xf-p_OffL , l_BiggestX := l_X0+p_OffR
   If ( l_Y0 < p_yf ) ; compare the initial and final Y
      l_SmallestY := l_Y0-p_OffT , l_BiggestY := p_Yf+p_OffB
   Else
      l_SmallestY := p_Yf-p_OffT , l_BiggestY := l_Y0+p_OffB

   Random, l_Points, %p_Min%, %p_Max% ; get a random number of points/splines
   l_Points-- ; decrease 1, because the first point (X0,Y0) is already set
   Loop, % l_Points-1 { ; we will also not count in this loop the last coordinate...
      Random, l_X%A_Index%, %l_SmallestX%, %l_BiggestX%
      Random, l_Y%A_Index%, %l_SmallestY%, %l_BiggestY%
   }
   l_X%l_Points% := p_Xf, l_Y%l_Points% := p_Yf ; ...so we can set it correctly here

   N := l_Points ; since we decreased 1 previously, we will later loop N+1 points (from 0 to N)

   l_TElapsed := ( l_TInitial := A_TickCount ) + p_Time ; set initial and elapsed time

   While ( A_TickCount < l_TElapsed ) ; run while it doesn't timeout
   {
      T := ( A_TickCount - l_TInitial ) / p_Time ; T is t in the formula
      U := ( l_TElapsed - A_TickCount ) / p_Time ; U is (1-t) in the formula
      l_X := 0, l_Y := 0 ; initally 0 so the proper values can be summed
      Loop, % N + 1 { ; now, we will loop N+1 points (from 0 to N)
         I := A_Index - (F1 := F2 := F3 := 1) ; adjust index (start as 0) and the factorial variables
         Loop, %N% ; calculating factorial 1
            F1 *= A_Index ; ( F1 = Fat(N) ) ; (this is why we needed N as the total number of points minus 1)
         Loop, %I% ; calculating factorial 2
            F2 *= A_Index ; ( F2 = Fat(I) )
         Loop, % N-I ; calculating factorial 3
            F3 *= A_Index ; ( F3 = Fat(N-I) )
         C := F1/(F2*F3) ; coefficient, calculated from 3 factorials
         T += 0.000001 , U -= 0.000001 ; adjust to avoid the mistake of using coordinates 0,0 (happens on the first iterations)
         MULT := C * (T**I) * (U**(N-I)) ; final multiplier for the coordinates
         l_X += MULT * l_X%I% ; set X coordinate
         l_Y += MULT * l_Y%I% ; set Y coordinate
      }
      MouseMove, %l_X%, %l_Y%, 0 ; no need for Round() since MouseMove corrects the position when receiving floats
      Sleep, 1
   }

   MouseMove, l_X%N%, l_Y%N%, 0 ; variables with index N have the last points, so move the mouse there

   ToolTip, % "Points:`t" N+1 ;; DEBUG

}