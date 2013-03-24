;**********************************************************************************
;
; Gdip_ImageSearch()
; by MasterFocus - 23/MARCH/2013 21:00h BRT
; Thanks to guest3456 for helping me ponder some ideas
; Requires GDIP, Gdip_SetBitmapTransColor() and Gdip_MultiLockedBitsSearch()
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_ImageSearch(pBitmapHaystack,pBitmapNeedle,ByRef OutputList="", ByRef OutputCount=""
,OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=""
,SearchDirection=1,Instances=0,LineDelim="`n",CoordDelim=",") {

    ; Some validations that can be done before proceeding any further
    If !( pBitmapHaystack && pBitmapNeedle )
        Return -1001
    If Variation not between 0 and 255
        return -1002
    If ( ( OuterX1 < 0 ) || ( OuterY1 < 0 ) )
        return -1003
    If SearchDirection not between 1 and 4
        SearchDirection := 1
    If ( Instances < 0 )
        Instances := 0

    ; Getting the dimensions and locking the bits [haystack]
    Gdip_GetImageDimensions(pBitmapHaystack,hWidth,hHeight)
    ; Last parameter being 1 says the LockMode flag is "READ only"
    If Gdip_LockBits(pBitmapHaystack,0,0,hWidth,hHeight,hStride,hScan,hBitmapData,1)
    OR !(hWidth := NumGet(hBitmapData,0))
    OR !(hHeight := NumGet(hBitmapData,4))
        Return -1004

    ; Careful! From this point on, we must do the following before returning:
    ; - unlock haystack bits

    ; Getting the dimensions and locking the bits [needle]
    Gdip_GetImageDimensions(pBitmapNeedle,nWidth,nHeight)
    ; If Trans is correctly specified, create a backup of the original needle bitmap
    ; and modify the current one, setting the desired color as transparent.
    ; Also, since a copy is created, we must remember to dispose the new bitmap later.
    ; This whole thing has to be done before locking the bits.
    If Trans between 0 and 0xFFFFFF
    {
        pOriginalBmpNeedle := pBitmapNeedle
        pBitmapNeedle := Gdip_CloneBitmapArea(pOriginalBmpNeedle,0,0,nWidth,nHeight)
        Gdip_SetBitmapTransColor(pBitmapNeedle,Trans)
        DumpCurrentNeedle := true
    }

    ; Careful! From this point on, we must do the following before returning:
    ; - unlock haystack bits
    ; - dispose current needle bitmap (if necessary)

    If Gdip_LockBits(pBitmapNeedle,0,0,nWidth,nHeight,nStride,nScan,nBitmapData)
    OR !(nWidth := NumGet(nBitmapData,0))
    OR !(nHeight := NumGet(nBitmapData,4))
    {
        If ( DumpCurrentNeedle )
            Gdip_DisposeImage(pBitmapNeedle)
        Gdip_UnlockBits(pBitmapHaystack,hBitmapData)
        Return -1005
    }
    
    ; Careful! From this point on, we must do the following before returning:
    ; - unlock haystack bits
    ; - unlock needle bits
    ; - dispose current needle bitmap (if necessary)

    ; Adjust the search box. "OuterX2,OuterY2" will be the last pixel evaluated
    ; as possibly matching with the needle's first pixel. So, we must avoid going
    ; beyond this maximum final coordinate.
    OuterX2 := ( !OuterX2 ? hWidth-nWidth+1 : OuterX2-nWidth+1 )
    OuterY2 := ( !OuterY2 ? hHeight-nHeight+1 : OuterY2-nHeight+1 )

    OutputCount := Gdip_MultiLockedBitsSearch(hStride,hScan,hWidth,hHeight
    ,nStride,nScan,nWidth,nHeight,OutputList,OuterX1,OuterY1,OuterX2,OuterY2
    ,Variation,SearchDirection,Instances,LineDelim,CoordDelim)

    Gdip_UnlockBits(pBitmapHaystack,hBitmapData)
    Gdip_UnlockBits(pBitmapNeedle,nBitmapData)
    If ( DumpCurrentNeedle )
        Gdip_DisposeImage(pBitmapNeedle)

    Return 0
}

;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;**********************************************************************************
;
; Gdip_SetBitmapTransColor()
; by MasterFocus - 23/MARCH/2013 21:00h BRT
; Requires GDIP
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
;
;**********************************************************************************

;==================================================================================
;
; This function modifies the Alpha component for all pixels of a certain color to 0
; The returned value is 0 in case of success, or a negative number otherwise
;
; pBitmap
;   A valid pointer to the bitmap that will be modified
;
; TransColor
;   The color to become transparent
;   Should range from 0 (black) to 0xFFFFFF (white)
;
;==================================================================================

Gdip_SetBitmapTransColor(pBitmap,TransColor) {
    static _SetBmpTrans, Ptr, PtrA
    if !( _SetBmpTrans ) {
        Ptr := A_PtrSize ? "UPtr" : "UInt"
        PtrA := Ptr . "*"
        MCode_SetBmpTrans := "
            (LTrim Join
            518b44241085c07e6b8b4c240c5355568b74242433ed578b7c2418896c24109085c97e3d8bc58d142f8bd9bd020000
            008a0c2a3a4e0275148a4c38013a4e01750b8a0a3a0e7505c64438030083c00483c2044b75db8b6c24108b4424208b4c241c
            036c242448896c24108944242075b05f5e5d5b59c3,4883ec08448bda4585c07e5948891c24458bd04c8b4424304963d
            94c8d4901904585db7e34498bc1498bd30f1f440000410fb648023848017516410fb648013808750d410fb6083848ff7504c
            64002004883c00448ffca75d74c03cb49ffca75bf488b1c244883c408c3
            )"
        if ( A_PtrSize == 8 ) ; x64, after comma
            MCode_SetBmpTrans := SubStr(MCode_SetBmpTrans,InStr(MCode_SetBmpTrans,",")+1)
        else ; x86, before comma
            MCode_SetBmpTrans := SubStr(MCode_SetBmpTrans,1,InStr(MCode_SetBmpTrans,",")-1)
        VarSetCapacity(_SetBmpTrans, LEN := StrLen(MCode_SetBmpTrans)//2, 0)
        Loop, %LEN%
            NumPut("0x" . SubStr(MCode_SetBmpTrans, (2*A_Index)-1, 2), _SetBmpTrans, A_Index-1, "uchar")
        MCode_SetBmpTrans := ""
        DllCall("VirtualProtect", Ptr, &_SetBmpTrans, Ptr, VarSetCapacity(_SetBmpTrans), "uint", 0x40, PtrA, 0)
    }
    If !pBitmap
        Return -1
    If TransColor not between 0 and 0xFFFFFF
        Return -2
    Gdip_GetImageDimensions(pBitmap,W,H)
    If !(W && H)
        Return -3
    Gdip_LockBits(pBitmap,0,0,W,H,Stride,Scan,BitmapData)
    ; The following code should be slower than using the MCode approach,
    ; but will the kept here for now, just for reference.
    /*
    Count := 0
    Loop, %H% {
        Y := A_Index-1
        Loop, %W% {
            X := A_Index-1
            CurrentColor := Gdip_GetLockBitPixel(Scan,X,Y,Stride)
            If ( (CurrentColor & 0xFFFFFF) == TransColor )
                Gdip_SetLockBitPixel(TransColor,Scan,X,Y,Stride), Count++
        }
    }
    */
    ; Thanks guest3456 for helping with this solution involving NumPut
    Gdip_FromARGB(TransColor,A,R,G,B), TransColor := "", VarSetCapacity(TransColor,3,255)
    NumPut(B,TransColor,0,"UChar"), NumPut(G,TransColor,1,"UChar"), NumPut(R,TransColor,2,"UChar")
    If DllCall( &_SetBmpTrans, Ptr,Scan, "int",W, "int",H, "int",Stride, Ptr,&TransColor, "cdecl int")
        Return 4
    Gdip_UnlockBits(pBitmap,BitmapData)
    Return 0
}

;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;**********************************************************************************
;
; Gdip_MultiLockedBitsSearch()
; by MasterFocus - 23/MARCH/2013 21:00h BRT
; Requires GDIP and Gdip_LockedBitsSearch()
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_MultiLockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan,nWidth,nHeight
,ByRef OutputList="",OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0
,SearchDirection=1,Instances=0,LineDelim="`n",CoordDelim=",")
{
    OutputList := ""
    OutputCount := !Instances
    InnerX1 := OuterX1 , InnerY1 := OuterY1
    InnerX2 := OuterX2 , InnerY2 := OuterY2
    While (!(OutputCount == Instances) && !Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride
    ,nScan,nWidth,nHeight,FoundX,FoundY,OuterX1,OuterY1,OuterX2,OuterY2,Variation,SearchDirection))
    {
        OutputCount++
        OutputList .= LineDelim FoundX CoordDelim FoundY
        If ( SearchDirection == 1 ) {
            OuterY1 := FoundY+1
            InnerX1 := FoundX+1
            InnerY1 := FoundY
            InnerY2 := InnerY1+1
        }
        Else If ( SearchDirection == 2 ) {
            OuterY2 := FoundY
            InnerX1 := FoundX+1
            InnerY1 := FoundY
            InnerY2 := InnerY1+1
        }
        Else If ( SearchDirection == 3 ) {
            OuterY2 := FoundY ; -1
            InnerX2 := FoundX ; -1
            InnerY1 := FoundY
            InnerY2 := InnerY1+1
        }
        Else If ( SearchDirection == 4 ) {
            OuterY1 := FoundY+1
            InnerX2 := FoundX ; -1
            InnerY1 := FoundY
            InnerY2 := InnerY1+1
        }
        While (!(OutputCount == Instances) && !Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride
        ,nScan,nWidth,nHeight,FoundX,FoundY,InnerX1,InnerY1,InnerX2,InnerY2,Variation,SearchDirection))
        {
            OutputCount++
            OutputList .= LineDelim FoundX CoordDelim FoundY
            If ( SearchDirection == 1 )
                InnerX1 := FoundX+1
            Else If ( SearchDirection == 2 )
                InnerX1 := FoundX+1
            Else If ( SearchDirection == 3 )
                InnerX2 := FoundX ; -1
            Else If ( SearchDirection == 4 )
                InnerX2 := FoundX ; -1
        }
    }
    OutputList := SubStr(OutputList,1+StrLen(LineDelim))
    OutputCount -= !Instances
    Return OutputCount
}

;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;**********************************************************************************
;
; Gdip_LockedBitsSearch()
; by MasterFocus - 23/MARCH/2013 21:00h BRT
; Mostly adapted from previous work by tic and Rseding91
;
; Requires GDIP
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
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
; Variation
;   Same as the builtin ImageSearch command
;   Default: 0
;
; sd
;   Search direction:
;   1 = top->left->right->bottom [default]
;   2 = bottom->left->right->top
;   3 = bottom->right->left->top (NOT WORKING!)
;   4 = top->right->left->bottom (NOT WORKING!)
;   This value is passed to the internal MCoded function
;
;==================================================================================

Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan,nWidth,nHeight
,ByRef x="",ByRef y="",sx1=0,sy1=0,sx2=0,sy2=0,Variation=0,sd=1)
{
    static _ImageSearch, Ptr, PtrA

    ; Initialize all MCode stuff, if necessary
    if !( _ImageSearch ) {
        Ptr := A_PtrSize ? "UPtr" : "UInt"
        PtrA := Ptr . "*"

        MCode_ImageSearch := "
            (LTrim Join
            8b44243883ec205355565783f8010f85940100008b7c2458897c24143b7c24600f8d450100008b44244c8b5c245c8b
            4c24448b7424548be80fafef896c242490897424683bf30f8d0a0100008d64240033c033db8bf5896c241c895c2420894424
            183b4424480f8d1e01000033c08944241085c90f8e9d0000008b5424688b7c24408beb8d34968b54246403df8d4900b80300
            0000803c18008b442410745e8b44243c0fb67c2f020fb64c06028d04113bf87f792bca3bf97c738b44243c0fb64c06018b44
            24400fb67c28018d04113bf87f5a2bca3bf97c548b44243c0fb63b0fb60c068d04113bf87f422bca3bf97c3c8b4424108b7c
            24408b4c24444083c50483c30483c604894424103bc17c818b5c24208b74241c0374244c8b44241840035c24508974241ce9
            2dffffff8b6c24688b5c245c8b4c244445896c24683beb8b6c24240f8c06ffffff8b44244c8b7c24148b7424544703e8897c
            2414896c24243b7c24600f8cd5feffff8b4424345fc700ffffffff8b4424345e5dc700ffffffff83c8ff5b83c420c38b4424
            348b4c246889088b4424388b4c24145f5e5d890833c05b83c420c383f8020f85850100008b7c24604f897c24103b7c24587c
            ab8b44244c8b5c245c8b4c24448bef0fafe8f7d8894424188b4424548b742418896c2428894424683bc30f8d0f0100009033
            c033db8bf5896c2420895c241c894424243b4424480f8d0c01000033c08944241485c90f8ea50000008b5424688b7c24408b
            eb8d34968b54246403df8d4900b803000000803c03008b44241474628b44243c0fb67c2f020fb64c06028d04113bf80f8f7d
            0000002bca3bf97c778b44243c0fb64c06018b4424400fb67c28018d04113bf87f5e2bca3bf97c588b44243c0fb63b0fb60c
            068d04113bf87f462bca3bf97c408b4424148b7c24408b4c24444083c50483c30483c604894424143bc10f8c79ffffff8b5c
            241c8b7424200374244c8b44242440035c245089742420e925ffffff8b6c24688b5c245c8b4c244445896c24683beb8b6c24
            280f8cfefeffff8b7c24108b4424548b7424184f03ee897c2410896c24283b7c24580f8dd0feffffe953feffff8b4424348b
            4c246889088b4424388b4c24105f5e5d890833c05b83c420c383f8030f856d0100008b7c24604f897c24103b7c24580f8c19
            feffff8b44244c8b6c245c8b5c24548b4c24448bf70faff04df7d8896c242c897424188944241ceb088da424000000009089
            6c24683beb0f8c020100008d64240033c033db89742424895c2420894424283b4424480f8d6effffff33c08944241485c90f
            8e9f0000008b5424688b7c24408beb8d34968b54246403dfeb038d4900b803000000803c18008b442414745e8b44243c0fb6
            7c2f020fb64c06028d04113bf87f752bca3bf97c6f8b44243c0fb64c06018b4424400fb67c28018d04113bf87f562bca3bf9
            7c508b44243c0fb63b0fb60c068d04113bf87f3e2bca3bf97c388b4424148b7c24408b4c24444083c50483c30483c6048944
            24143bc17c818b5c24208b7424248b4424280374244c40035c2450e92bffffff8b6c24688b5c24548b4c24448b7424184d89
            6c24683beb0f8d0affffff8b7c24108b44241c4f03f0897c2410897424183b7c24580f8cc8fcffff8b6c242ce9d4feffff83
            f8040f85b6fcffff8b7c2458897c24103b7c24600f8da4fcffff8b44244c8b6c245c8b5c24548b4c24444d8bf00faff7896c
            242c8974241ceb098da424000000008bff896c24683beb0f8c020100008d64240033c033db89742424895c2420894424283b
            4424480f8dfefdffff33c08944241485c90f8e9f0000008b5424688b7c24408beb8d34968b54246403dfeb038d4900b80300
            0000803c18008b442414745e8b44243c0fb67c2f020fb64c06028d04113bf87f752bca3bf97c6f8b44243c0fb64c06018b44
            24400fb67c28018d04113bf87f562bca3bf97c508b44243c0fb63b0fb604068d0c103bf97f3e2bc23bf87c388b4424148b7c
            24408b4c24444083c50483c30483c604894424143bc17c818b5c24208b7424248b4424280374244c40035c2450e92bffffff
            8b6c24688b5c24548b4c24448b74241c4d896c24683beb0f8d0affffff8b44244c8b7c24104703f0897c24108974241c3b7c
            24600f8d58fbffff8b6c242ce9d4feffff,4c894c24204c89442418488954241048894c2408535556574154415541564
            1574883ec188b8424c80000004d8bd9488bda83f8010f859c010000448b8c24a800000044890c24443b8c24b80000000f8d5
            d010000448bac24900000008b9424c0000000448b8424b00000008bbc2480000000448b9424a0000000418bcd410fafc9894
            c240444899424c8000000453bd00f8dfa000000468d24950000000066904533f6448bf933f60f1f840000000000443bb4248
            80000000f8dfc05000033db85ff0f8e7c000000418bec448bce2bee4103ef4d63c14d03c34180780300745a450fb65002418
            d04294c63d84c035c2470410fb64b028d0411443bd07f582bca443bd17c51410fb64b01450fb650018d0411443bd07f3f2bc
            a443bd17c38410fb60b450fb6108d0411443bd07f282bca443bd17c214c8b5c2478ffc34183c1043bdf7c8f41ffc64503fd0
            3b42498000000e95affffff8b8424c8000000448b8424b00000008b4c24044c8b5c2478ffc04183c404898424c8000000413
            bc00f8c1cffffff448b0c24448b9424a000000041ffc14103cd44890c24894c2404443b8c24b80000000f8cd9feffff488b5
            c2468488b4c246083c8ffc701ffffffffc703ffffffff4883c418415f415e415d415c5f5e5d5bc383f8020f8585010000448
            b8c24b800000041ffc944890c24443b8c24a80000007cb9448bac2490000000448b8424c00000008b9424b00000008bbc248
            0000000448b9424a0000000418bc9410fafcd418bc5894c2404f7d88944240844899424c8000000443bd20f8dff000000468
            d2495000000000f1f44000033ed448bf933f6660f1f8400000000003bac24880000000f8d4d04000033db85ff0f8e8200000
            0458bf4448bd6442bf64503f74963d24903d3807a03007460440fb64a02438d04164c63d84c035c2470410fb64b02428d040
            1443bc87f5c412bc8443bc97c54410fb64b01440fb64a01428d0401443bc87f41412bc8443bc97c39410fb60b440fb60a428
            d0401443bc87f28412bc8443bc97c204c8b5c2478ffc34183c2043bdf7c8affc54503fd03b42498000000e956ffffff8b842
            4c80000008b9424b00000008b4c24044c8b5c2478ffc04183c404898424c80000003bc20f8c1affffff448b0c24448b9424a
            0000000034c240841ffc9894c240444890c24443b8c24a80000000f8dd3feffffe948feffff83f8030f85c5010000448b8c2
            4b800000041ffc944898c24c8000000443b8c24a80000000f8c23feffff8b842490000000448b9c24b0000000448b8424c00
            000008bbc248000000041ffcb418bc98bd044895c24080fafc8f7da890c24895424048b9424a0000000448b542404458beb4
            43bda0f8c14010000468d249d000000006666660f1f84000000000033ed448bf933f6660f1f8400000000003bac248800000
            00f8d0801000033db85ff0f8e96000000488b4c2478458bf4448bd6442bf64503f70f1f8400000000004963d24803d1807a0
            3007460440fb64a02438d04164c63d84c035c2470410fb64b02428d0401443bc87f63412bc8443bc97c5b410fb64b01440fb
            64a01428d0401443bc87f48412bc8443bc97c40410fb60b440fb60a428d0401443bc87f2f412bc8443bc97c27488b4c2478f
            fc34183c2043bdf7c8a8b842490000000ffc54403f803b42498000000e942ffffff8b9424a00000008b8424900000008b0c2
            441ffcd4183ec04443bea0f8d11ffffff448b8c24c8000000448b542404448b5c240841ffc94103ca44898c24c8000000890
            c24443b8c24a80000000f8dc1feffffe997fcffff488b4c24608b8424c8000000448929488b4c2468890133c0e993fcffff8
            3f8040f8576fcffff448b8c24a800000044890c24443b8c24b80000000f8d5cfcffff448bac2490000000448b9424b000000
            08b9424c0000000448b8424a00000008bbc248000000041ffca418bcd4489542408410fafc9894c2404669044899424c8000
            000453bd00f8cf8000000468d2495000000000f1f800000000033ed448bf933f6660f1f8400000000003bac24880000000f8
            ded00000033db85ff7e7e458bf4448bce442bf64503f7904d63c14d03c34180780300745a450fb65002438d040e4c63d84c0
            35c2470410fb64b028d0411443bd07f572bca443bd17c50410fb64b01450fb650018d0411443bd07f3e2bca443bd17c37410
            fb603450fb6108d0c10443bd17f272bc2443bd07c204c8b5c2478ffc34183c1043bdf7c8fffc54503fd03b42498000000e95
            effffff8b8424c8000000448b8424a00000008b4c24044c8b5c2478ffc84183ec04898424c8000000413bc00f8d20ffffff4
            48b0c24448b54240841ffc14103cd44890c24894c2404443b8c24b80000000f8cdbfeffffe9f2faffff488b4c24608b8424c
            800000089018b0424488b4c2468890133c0e9ecfaffff
            )"
        if ( A_PtrSize == 8 ) ; x64, after comma
            MCode_ImageSearch := SubStr(MCode_ImageSearch,InStr(MCode_ImageSearch,",")+1)
        else ; x86, before comma
            MCode_ImageSearch := SubStr(MCode_ImageSearch,1,InStr(MCode_ImageSearch,",")-1)
        VarSetCapacity(_ImageSearch, LEN := StrLen(MCode_ImageSearch)//2, 0)
        Loop, %LEN%
            NumPut("0x" . SubStr(MCode_ImageSearch, (2*A_Index)-1, 2), _ImageSearch, A_Index-1, "uchar")
        MCode_ImageSearch := ""
        DllCall("VirtualProtect", Ptr, &_ImageSearch, Ptr, VarSetCapacity(_ImageSearch), "uint", 0x40, PtrA, 0)
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

    ; The DllCall parameters are the same for easier C code modification,
    ; even though they aren't all used on the _ImageSearch version
    x := 0, y := 0
    , E := DllCall( &_ImageSearch, "int*",x, "int*",y, Ptr,hScan, Ptr,nScan, "int",nWidth, "int",nHeight
    , "int",hStride, "int",nStride, "int",sx1, "int",sy1, "int",sx2, "int",sy2, "int",Variation
    , "int",sd, "cdecl int")
    return (E = "") ? -1107 : E
}