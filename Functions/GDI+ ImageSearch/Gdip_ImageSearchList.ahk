;**********************************************************************************
;
; Gdip_ImageSearchList() by MasterFocus - 07/MARCH/2013 02:45h BRT
; Requires Gdip_FastImageSearch() by MasterFocus
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition exclusively for these users:
; - tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_ImageSearchList(Haystack="Screen",Needle="") {
;-----------------------------------------
    OuterX1 := OuterY1 := 0
    OuterX2 := A_ScreenWidth
    OuterY2 := A_ScreenHeight
    VARI := TRANS := W := H := 0
    DIR := KEEP := 1
    LineDelim := "`n"
    CoordDelim := ","
;-----------------------------------------
    InnerX1 := OuterX1
    InnerY1 := OuterY1
    InnerX2 := OuterX2
    InnerY2 := OuterY2
    While !Gdip_FastImageSearch(Haystack,Needle,FoundX,FoundY,OuterX1,OuterY1,OuterX2,OuterY2,VARI,TRANS,W,H,DIR,KEEP,NeedleWidth,NeedleHeight)
    {
        ;;MOUSEMOVE, %FoundX%, %FoundY%, 0
        ;;TOOLTIP, % "Found in outer while-loop, " FoundX "," FoundY
        OuterY1 := FoundY+1
        OutputList .= LineDelim FoundX CoordDelim FoundY
        InnerX1 := FoundX+1
        InnerY1 := FoundY
        InnerY2 := InnerY1+NeedleHeight
        While !Gdip_FastImageSearch(Haystack,Needle,FoundX,FoundY,InnerX1,InnerY1,InnerX2,InnerY2,VARI,TRANS,W,H,DIR,KEEP)
        {
            ;;MOUSEMOVE, %FoundX%, %FoundY%, 0
            ;;TOOLTIP, % "Found in inner while-loop, " FoundX "," FoundY
            OutputList .= LineDelim FoundX CoordDelim FoundY
            InnerX1 := FoundX+1
        }
    }
    Gdip_FastImageSearch()
    Return SubStr(OutputList,1+StrLen(LineDelim))
}