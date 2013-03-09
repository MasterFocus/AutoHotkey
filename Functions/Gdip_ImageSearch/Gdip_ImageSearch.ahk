;**********************************************************************************
;
; Gdip_ImageSearch()
; by MasterFocus - 09/MARCH/2013 09:15h BRT
; Thanks to guest3456 for helping me ponder some ideas
; Requires GDIP and Gdip_MultiLockedBitsSearch()
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition EXCLUSIVELY for these users:
; - tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_ImageSearch(pBitmapHaystack,pBitmapNeedle,ByRef OutputList="", ByRef OutputCount=""
,OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=0
,SearchDirection=0,Instances=0,LineDelim="`n",CoordDelim=",") {

    ; Some validations that can be done before proceeding any further
    If ( (pBitmapHaystack == "") OR (pBitmapNeedle == "") )
        Return -1001
    If Variation not between 0 and 255
        return -1002
    If ( ( OuterX1 < 0 ) || ( OuterY1 < 0 ) )
        return -1003
    If SearchDirection not between 0 and 4
        SearchDirection := 1
    If ( Instances < 0 )
        Instances := 0

    ; Getting the dimensions and locking the bits [haystack]
    Gdip_GetImageDimensions(pBitmapHaystack,hWidth,hHeight)
    If Gdip_LockBits(pBitmapHaystack,0,0,hWidth,hHeight,hStride,hScan,hBitmapData)
    OR !(hWidth := NumGet(hBitmapData,0))
    OR !(hHeight := NumGet(hBitmapData,4))
        Return -1004

    ; Getting the dimensions and locking the bits [needle]
    Gdip_GetImageDimensions(pBitmapNeedle,nWidth,nHeight)
    ; If Trans is used, create a copy because it might be modified by the ImageSearch MCode
    ; This has to be done before locking the bits
    If Trans
        pBitmapNeedle := Gdip_CloneBitmapArea(pBitmapNeedle,0,0,nWidth,nHeight)
    If Gdip_LockBits(pBitmapNeedle,0,0,nWidth,nHeight,nStride,nScan,nBitmapData)
    OR !(nWidth := NumGet(nBitmapData,0))
    OR !(nHeight := NumGet(nBitmapData,4))
        Return -1005

    ; Careful: from this point on, we must unlock the bits before returning

    ; Adjust the search box. "OuterX2,OuterY2" will be the last pixel evaluated
    ; as possibly matching with the needle's first pixel. So, we must avoid going
    ; beyond this maximum final coordinate.
    OuterX2 := ( !OuterX2 ? hWidth-nWidth+1 : OuterX2-nWidth+1 )
    OuterY2 := ( !OuterY2 ? hHeight-nHeight+1 : OuterY2-nHeight+1 )

    /*
    If ( (OuterX2-OuterX1 < 1) || (OuterY2-OuterY1 < 1) )
    {
        Gdip_UnlockBits(pBitmapHaystack,hBitmapData)
        Gdip_UnlockBits(pBitmapNeedle,nBitmapData)
        return -1006
    }
    
    If ( OuterX2 > (hWidth-nWidth+1) )
        OuterX2 := hWidth-nWidth+1
    If ( OuterY2 > (hHeight-nHeight+1) )
        OuterY2 := hHeight-nHeight+1
    
    If ( (OuterX2<OuterX1) || (OuterY2<OuterY1) )
    {
        Gdip_UnlockBits(pBitmapHaystack,hBitmapData)
        Gdip_UnlockBits(pBitmapNeedle,nBitmapData)
        return -1007
    }
    
    OuterX2 += !OuterX2
    OuterY2 += !OuterY2
    */
    
    OutputCount := Gdip_MultiLockedBitsSearch(hStride,hScan,hWidth,hHeight
    ,nStride,nScan,nWidth,nHeight,OutputList,OuterX1,OuterY1,OuterX2,OuterY2
    ,Variation,Trans,SearchDirection,Instances,LineDelim,CoordDelim)

    Gdip_UnlockBits(pBitmapHaystack,hBitmapData)
    Gdip_UnlockBits(pBitmapNeedle,nBitmapData)

    Return 0
}

;**********************************************************************************
;
; Gdip_LockedBitsSearch(), previously called Gdip_ImageSearch()
; by MasterFocus - 09/MARCH/2013 09:15h BRT
; Mostly adapted from previous work by tic and Rseding91
;
; Requires GDIP
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition EXCLUSIVELY for these users:
; - tic , Rseding91 , guest3456
;
;**********************************************************************************

;==================================================================================
;
; hStride, hScan, hWidth and hHeight
;   Haystack stuff, extracted from a BitmapData, extracted from a Bitmap
;
; nStride, nScan, nWidth and nHeight
;   Needle stuff, extracted from a BitmapData, extracted from a Bitmap
;
; x and y
;   ByRef variables to store the X and Y coordinates of the image if it's found
;   Default: "" for both
;
; sx1, sy1, sx2 and sy2
;   These can be used to crop the search area within the haystack
;   Default: "" for all (does not crop)
;
; Variation and Trans
;   Same as the builtin ImageSearch command
;   Default: 0 for both
;
; sd
;   Search direction:
;   0 = auto detect best direction [default]
;   1 = left->right, top->bottom ;; 2 = left->right, bottom->top
;   3 = right->left, bottom->top ;; 4 = right->left, top->bottom
;   This value is passed to the internal MCoded function
;
;==================================================================================

Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan,nWidth,nHeight
,ByRef x="",ByRef y="",sx1=0,sy1=0,sx2=0,sy2=0,Variation=0,Trans=0,sd=0)
{
    static _ImageSearch1, _ImageSearch2, _PixelAverage, Ptr, PtrA

    ; Initialize all MCode stuff, if necessary
    if !_ImageSearch1
    {
        Ptr := A_PtrSize ? "UPtr" : "UInt"
        , PtrA := A_PtrSize ? "UPtr*" : "UInt*"
        
        MCode_ImageSearch1 := "8B4C243483EC10803900538B5C2434555657750C80790100750680790200744B8B54243885D27E478B7C2430478BEA908B7424"
        . "3485F67E2C8BC78D9B000000008A50013A510275128A103A5101750B8A50FF3A117504C640020083C0044E75E08B54243803FB4D75C7EB048B5424388B"
        . "4424488944241C3B4424500F8D800200008B4C243C8BF90FAFF88D4402FF0FAFC1897C2418894424148DA424000000008B742444897424543B74244C0F"
        . "8D300200008B74245C83FE0175648B6C243033D2453B5424380F8D5402000033F6397424347E428B4C24548B5C242C8D0C8F8BC58D4C19018A58013A59"
        . "01750E8A183A1975088A58FF3A59FF740A807802000F85B60100004683C10483C0043B7424347CD38B5C2440037C243C4203EBEBA383FE020F85860000"
        . "008BF88BC14A8BCBF7D8F7D98BF20FAFF38B5C243089442410894C24488D6C1E01EB068D9B0000000083FAFF0F8EC701000033F6397424347E468B4C24"
        . "548B5C242C8D0C8F8BC58D4C19018A58013A5901750E8A183A1975088A58FF3A59FF740A807802000F85290100004683C10483C0043B7424347CD38B44"
        . "24108B4C244803F84A03E9EBA283FE030F85840000004A8BFAF7D90FAFFB8BF3F7DE8BE8894C2410897424488D490083FAFF0F8E470100008B44243448"
        . "83F8FF7E518B7424308B5C242C8D0C878D4C31018B74245403F08D74B5008D741E018A59013A5E01750E8A193A1E75088A59FF3A5EFF740A807902000F"
        . "859B0000004883EE0483E90483F8FF7FD48B7424488B4C241003E94A03FEEB9583FE040F85DC00000033ED896C24488D9B00000000395424480F8DC600"
        . "00008B4424344883F8FF7E4D8B4C24308B74242C8D5485008D4C0A018B54245403D08D14978D7432018A51013A5601750E8A113A1675088A51FF3A56FF"
        . "74068079020075224883EE0483E90483F8FF7FD88B5424388B4C243CFF44244803F903EBEB958B5C24408B4424548B7C24188B5424388B4C243C403B44"
        . "244C894424548B4424140F8CD0FDFFFF8B74241C4603C103F98974241C89442414897C24183B7424500F8C9FFDFFFF8B4C24248B5424285F5E5DC701FF"
        . "FFFFFFC702FFFFFFFF83C8FF5B83C410C38B4424248B4C24548B5424285F89088B4424185E5D890233C05B83C410C3"
        
        MCode_ImageSearch2 := "8B4C24348B54241883EC2C803900538B5C2450555657750C80790100750680790200744E8B6C244C85D27E4A8D7D0189542470"
        . "8B74245085F67E298BC78D49008A50013A510275128A103A5101750B8A50FF3A117504C640020083C0044E75E08B6C244C03FBFF4C247075C78B542454"
        . "EB048B6C244C8B442464894424183B44246C0F8D0C0400008B7C24588B74247C8BCF0FAFC8894C24148B8C248000000003C88D4402FF0FAFCF0FAFC789"
        . "4424108B442474894C2430EB068D9B000000008B4C2460894C24643B4C24680F8DA40300008BD30FAF94248000000003D58D0CB20FB611894C24348B4C"
        . "246003CE8B7424308D0C8E034C244889542438894C242CEB048B4C242C0FB6098D34013BD67F062BC83BD17D0E8B4C2434807903000F85350300008B4C"
        . "247883F9010F85AD0000008B742414C7442470000000008D4D018B542470894C2424897424283B5424540F8D5C03000033ED396C24507E698B5424648D"
        . "14968B7424488D7432018BFF0FB656010FB679018D1C023BFB7F2E2BD03BFA7C280FB6160FB6398D1C023BFB7F1B2BD03BFA7C150FB656FF0FB679FF8D"
        . "1C023BFB7F062BD03BFA7D0A807902000F85930200004583C60483C1043B6C24507CAC8B5C245C8B7424288B4C242403742458FF44247003CBE962FFFF"
        . "FF83F9020F85C60000008B5424108B4C2454498954241C8BD78BF3F7DAF7DE8BF90FAFFB8D7C2F018954242889742424897C2420894C247083F9FF0F8E"
        . "9402000033ED396C24507E798B74241C8B5424648B4C24208D14968B7424488D7432018BFF0FB656010FB679018D1C023BFB7F2E2BD03BFA7C280FB616"
        . "0FB6398D1C023BFB7F1B2BD03BFA7C150FB656FF0FB679FF8D1C023BFB7F062BD03BFA7D0A807902000F85C30100004583C60483C1043B6C24507CAC8B"
        . "7424248B5424288B4C24700154241C4901742420E964FFFFFF83F9030F85D80000008B5424548B4C24104A894C24208BF78BCAF7DE0FAFCB8BFBF7DF89"
        . "742428897C2424894C241C8954247083FAFF0F8EC90100008B6C24504D83FDFF0F8E8B0000008B7424208D14A98B4C244C8D4C0A018B54246403D58D14"
        . "968B7424488D543201EB068D9B000000000FB672010FB679018D1C063BFB7F2E2BF03BFE7C280FB6320FB6398D1C063BFB7F1B2BF03BFE7C150FB672FF"
        . "0FB679FF8D1C063BFB7F062BF03BFE7D0A807902000F85E30000004D83EA0483E90483FDFF7FAD8B7C24248B7424288B4C241C8B542470017424204A03"
        . "CFE94AFFFFFF83F9040F851B0100008B74241433C9894C2470894C24288B4C2470897424243B4C24540F8DFB0000008B6C24504D83FDFF7E738B542428"
        . "8D0CAA8B54244C8D4C11018B54246403D58D14968B7424488D5432010FB672010FB679018D1C063BFB7F2E2BF03BFE7C280FB6320FB6398D1C063BFB7F"
        . "1B2BF03BFE7C150FB672FF0FB679FF8D1C063BFB7F062BF03BFE7D068079020075254D83EA0483E90483FDFF7FB18B5C245C8B74242403742458FF4424"
        . "70015C2428E95CFFFFFF8B5C245C8B6C244C8B7C24588B5424388B4C24648344242C0441894C24643B4C24680F8C91FCFFFF8B74247CFF4424188B4C24"
        . "18017C2410017C2414017C24303B4C246C0F8C2CFCFFFF8B4424408B4C24445F5EC700FFFFFFFF5DC701FFFFFFFF83C8FF5B83C42CC38B5424408B4424"
        . "648B4C24445F89028B5424145E5D891133C05B83C42CC3"
        
        MCode_PixelAverage := "83EC488B4C24608B54246433C0890189028944243C894424388B44245453992BC2558B6C246456578BF88B442468992BC28B54"
        . "24688D5D148D73148D4E14D1FF897E04D1F8894104894308897E088951088B542464897D0C89430C89560C8B54246889510C8B542464897D1089561089"
        . "41108BC52BD92BC18BFE8D51042BF9C74424340100000089542410895C24408944242C897C2430EB178DA424000000008B5424108B5C24408B44242C8B"
        . "7C24308B328B0C1333ED896C2468896C2464896C246C897424443BCE0F8D030100008B0410894424148B0417894424188BC10FAF4424602BF189442438"
        . "8974243C8BFF8B7424148B4C241833DB33FF896C241C896C2420896C2424896C24283BF10F8DA00000002BCE83F9027C538B54245C8D0CB08D4C11018B"
        . "5424182BD683EA02D1EA428D34560FB6410103F80FB60103D80FB641FF0144241C0FB64105014424280FB64104014424240FB641030144242083C1084A"
        . "75CF8B4424388B54241033ED3B7424187D1E8D0CB0034C245C0FB67102017424680FB671010FB60901742464014C246C8B4C24248B7424200374241C03"
        . "CB014C24648B4C24280174246C03CF014C246803442460FF4C243C894424380F852AFFFFFF8B5C24408B44242C8B7C24308B34138B3C172B3C108B0A8B"
        . "4424682BCE0FAFCF33D2F7F133D2896C24688BF88B442464F7F133D28BD88B44246CF7F18D57198954246C8D4B1983C7E783C3E7897C243C894C243889"
        . "5C24288D50198954242483C0E733D2894424203B7424440F8DAE0000008B4424108B4C242C8B0C01894C24148B4C24308B1C018BC60FAF442460895C24"
        . "1C894424648D49008B7C24143BFB7D6B8B4C245C8D04B88D4C080280790100744A0FB6018BDA3B44246C7D063B44243C7F01420FB641FF3B4424387D06"
        . "3B4424287F01420FB641FE3B4424247D063B4424207F01428BC22BC33B4424687E0C897C245089742454894424688B5C241C4783C1043BFB7CA48B4424"
        . "640344246046894424643B7424440F8C7AFFFFFF3B5424487E208B4424708B4C2450895424488B54243489088B4424548954244C8B54247489028B4424"
        . "348344241004408944243483F8050F8C7DFDFFFF8B44244C5F5E5D5B83C448C3"
        
        VarSetCapacity(_ImageSearch1, StrLen(MCode_ImageSearch1)//2, 0)
        Loop % StrLen(MCode_ImageSearch1)//2      ;%
            NumPut("0x" . SubStr(MCode_ImageSearch1, (2*A_Index)-1, 2), _ImageSearch1, A_Index-1, "uchar")
        MCode_ImageSearch1 := ""
        
        VarSetCapacity(_ImageSearch2, 1233, 0)
        Loop % StrLen(MCode_ImageSearch2)//2      ;%
            NumPut("0x" . SubStr(MCode_ImageSearch2, (2*A_Index)-1, 2), _ImageSearch2, A_Index-1, "uchar")
        MCode_ImageSearch2 := ""
        
        VarSetCapacity(_PixelAverage, StrLen(MCode_PixelAverage)//2, 0)
        Loop % StrLen(MCode_PixelAverage)//2      ;%
            NumPut("0x" . SubStr(MCode_PixelAverage, (2*A_Index)-1, 2), _PixelAverage, A_Index-1, "uchar")
        MCode_PixelAverage := ""
        
        , DllCall("VirtualProtect", Ptr, &_ImageSearch1, Ptr, VarSetCapacity(_ImageSearch1), "uint", 0x40, PtrA, 0)
        , DllCall("VirtualProtect", Ptr, &_ImageSearch2, Ptr, VarSetCapacity(_ImageSearch2), "uint", 0x40, PtrA, 0)
        , DllCall("VirtualProtect", Ptr, &_PixelAverage, Ptr, VarSetCapacity(_PixelAverage), "uint", 0x40, PtrA, 0)
    }

    ; Abort if an initial coordinates is located before a final coordinate
    If ( sx2 < sx1 )
        return -1101
    If ( sy2 < sy1 )
        return -1102

    ; Check the search box. "sx2,sy2" will be the last pixel evaluated
    ; as possibly matching with the needle's first pixel. So, we must
    ; avoid going beyond this maximum final coordinate.
    If ( sx2 > (hWidth-nWidth+1) )
        return -1103
    If ( sy2 > (hHeight-nHeight+1) )
        return -1104

    ; Abort if the width or height of the search box is 0
    If ( sx2-sx1 == 0 )
        return -1105
    If ( sy2-sy1 == 0 )
        return -1106

    ; I don't quite remember if these were really necessary,
    ; but commenting them doesn't seem to affect anything.
    ;sx2 += !sx2
    ;sy2 += !sy2

    ; Average the needle in 4 chunks, counting the number of pixels (R, G & B) that
    ; aren't +-25 of the average color and set the search code to scan that corner first
    ; when matching the image. Also, set a "Check this pixel first" location for the
    ; haystack instead of always starting at the corner of the image (0/0, w/h, ...)
    if (sd = 0 And nWidth >= 20 And nHeight >= 20){
        VarSetCapacity(TempData, 5*4*4, 0) ; 5 entires at 4 entires each at 4 bytes each
        , sd := DllCall(&_PixelAverage, Ptr, nScan, "Int", nStride, "Int", nWidth, "Int", nHeight, Ptr, &TempData
        , "UInt*", suX, "UInt*", suY, "cdecl int")
        , VarSetCapacity(TempData, 0)
    }
    else
        sd += !sd ; becomes 0 if it's 1, and stays unaltered otherwise
    
    ; Set the default search-first location for variation searches if none was set yet
    suX := (suX = "" || suX = -1) ? 0 : suX   ,   suY := (suY = "" || suY = -1) ? 0 : suY
    
    ; The DllCall parameters are the same for easier C code modification,
    ; even though they aren't all used on the _ImageSearch1 version
    x := 0, y := 0
    , E := DllCall((Variation = 0 ? &_ImageSearch1 : &_ImageSearch2), "int*", x, "int*", y, Ptr, hScan, Ptr, nScan, "int", nWidth
    , "int", nHeight, "int", hStride, "int", nStride, "int", sx1, "int", sy1, "int", sx2, "int", sy2, Ptr, &Trans, "int", Variation
    , "int", sd, "int", suX, "int", suY, "cdecl int")
    
    return (E = "") ? -1107 : E
}

;**********************************************************************************
;
; Gdip_MultiLockedBitsSearch(), previously called Gdip_ImageSearchList()
; by MasterFocus - 09/MARCH/2013 09:15h BRT
; Requires GDIP and Gdip_LockedBitsSearch()
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition EXCLUSIVELY for these users:
; - tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_MultiLockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan,nWidth,nHeight
,ByRef OutputList="",OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=0
,SearchDirection=0,Instances=0,LineDelim="`n",CoordDelim=",")
{
    OutputCount := 0 + (!Instances)
    InnerX1 := OuterX1 , InnerY1 := OuterY1
    InnerX2 := OuterX2 , InnerY2 := OuterY2
    While ( !(OutputCount == Instances) && !Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan
    ,nWidth,nHeight,FoundX,FoundY,OuterX1,OuterY1,OuterX2,OuterY2,Variation,Trans,SearchDirection) )
    {
        OutputCount++
        OutputList .= LineDelim FoundX CoordDelim FoundY
        OuterY1 := FoundY+1
        InnerX1 := FoundX+1
        InnerY1 := FoundY
        InnerY2 := InnerY1+1
        While ( !(OutputCount == Instances) && !Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan
        ,nWidth,nHeight,FoundX,FoundY,InnerX1,InnerY1,InnerX2,InnerY2,Variation,Trans,SearchDirection) )
        {
            OutputCount++
            OutputList .= LineDelim FoundX CoordDelim FoundY
            InnerX1 := FoundX+1
        }
    }
    OutputList := SubStr(OutputList,1+StrLen(LineDelim))
    OutputCount -= !Instances
    Return OutputCount
}