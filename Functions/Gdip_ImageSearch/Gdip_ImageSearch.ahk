;**********************************************************************************
;
; Gdip_ImageSearch()
; by MasterFocus - 23/MARCH/2013 02:00h BRT
; Thanks to guest3456 for helping me ponder some ideas
; Requires GDIP and Gdip_MultiLockedBitsSearch()
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_ImageSearch(pBitmapHaystack,pBitmapNeedle,ByRef OutputList="", ByRef OutputCount=""
,OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=0
,SearchDirection=1,Instances=0,LineDelim="`n",CoordDelim=",") {

    ; Some validations that can be done before proceeding any further
    If ( (pBitmapHaystack == "") OR (pBitmapNeedle == "") )
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
    ; If Trans is used, create a copy because it might be modified by the ImageSearch MCode
    ; Also, if a copy is created, we must be able to dispose this new bitmap later
    ; This whole thing has to be done before locking the bits
    If Trans
    {
        pOriginalBmpNeedle := pBitmapNeedle
        pBitmapNeedle := Gdip_CloneBitmapArea(pOriginalBmpNeedle,0,0,nWidth,nHeight)
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
    ,Variation,Trans,SearchDirection,Instances,LineDelim,CoordDelim)

    Gdip_UnlockBits(pBitmapHaystack,hBitmapData)
    Gdip_UnlockBits(pBitmapNeedle,nBitmapData)
    If ( DumpCurrentNeedle )
        Gdip_DisposeImage(pBitmapNeedle)

    Return 0
}

;**********************************************************************************
;
; Gdip_LockedBitsSearch(), previously called Gdip_ImageSearch()
; by MasterFocus - 23/MARCH/2013 02:00h BRT
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
; Variation and Trans
;   Same as the builtin ImageSearch command
;   Default: 0 for both
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
,ByRef x="",ByRef y="",sx1=0,sy1=0,sx2=0,sy2=0,Variation=0,Trans=0,sd=1)
{
    static _ImageSearch, Ptr, PtrA

    ; Initialize all MCode stuff, if necessary
    if !_ImageSearch
    {
        Ptr := A_PtrSize ? "UPtr" : "UInt"
        , PtrA := A_PtrSize ? "UPtr*" : "UInt*"

        MCode_ImageSearch := "
            (LTrim Join
            8b4c24188b44241483ec1c5355568b74245c57803e00750c807e01007506807e0200746485c97e6033db895c24608b
            e9894c241085c07e418b6c243c8bcb8d142b8bf8bb020000008a04133a460275148a4429013a4601750b8a023a067505c644
            29030083c10483c2044f75db8b5c24608b6c24108b442440035c244c4d895c2460896c241075ac8b44246883f8010f856f01
            00008b6c2454896c24683b6c245c0f8d8e0500008b4424488b5424648b4c24588b7424508bd80fafdd895c24208bfe897c24
            603bf10f8d020100008bff33c08bf38b5c244033c989742418894c241c894424143b4424440f8dfa00000033c08944241085
            db0f8e9b0000008b5c243c8be903d98d34beb9030000008bff803c1900745f8b4424380fb64c06028b44243c0fb67c28028d
            04113bf87f7c2bca3bf97c768b4424380fb64c06018b44243c0fb67c28018d04113bf87f5d2bca3bf97c578b4424380fb63b
            0fb60c068d04113bf87f452bca3bf97c3f8b442410b9030000004083c50483c30483c604894424103b4424407c878b4c241c
            8b7424188b7c24608b5c24408b4424140374244840034c244ce92fffffff8b7c24608b4c24588b5c242047897c24603bf90f
            8c0cffffff8b4424488b6c24688b7424504503d8896c2468895c24203b6c245c0f8cdbfeffffe94b0400008b4424308b4c24
            6889388b4424345f5e5d890833c05b83c41cc383f8020f855d0100008b6c245c4d896c24683b6c24540f8c150400008b4424
            488b5424648b4c24508bdd0fafd8f7d8894424108b4424588b742410895c24248bf9897c24603bc80f8dff00000033c08bf3
            8b5c244033c989742418894c24148944241c3b4424440f8d79ffffff33c08944242085db0f8e9a0000008b5c243c8be903d9
            8d34beb90300000090803c1900745f8b4424380fb64c06028b44243c0fb67c28028d04113bf87f7c2bca3bf97c768b442438
            0fb64c06018b44243c0fb67c28018d04113bf87f5d2bca3bf97c578b4424380fb63b0fb60c068d04113bf87f452bca3bf97c
            3f8b442420b9030000004083c50483c30483c604894424203b4424407c878b4c24148b7424188b7c24608b5c24408b44241c
            0374244840034c244ce930ffffff8b7c24608b4424588b5c242447897c24603bf80f8c0dffffff8b6c24688b4c24508b7424
            104d03de896c2468895c24243b6c24540f8ddefeffffe9cb02000083f8030f85670100008b6c245c4d896c24683b6c24540f
            8caf0200008b4424488b7424588b5424648bdd0fafd84ef7d8894424148b4424508b4c241489742428895c24108bff8bfe89
            7c24603bf80f8c020100008bff33c08bf38b5c244033c98974241c894c2418894424203b4424440f8d0afeffff33c0894424
            2485db0f8e9b0000008b5c243c8be903d98d34beb9030000008bff803c1900745f8b4424380fb64c06028b44243c0fb67c28
            028d04113bf87f7c2bca3bf97c768b4424380fb64c06018b44243c0fb67c28018d04113bf87f5d2bca3bf97c578b4424380f
            b63b0fb60c068d04113bf87f452bca3bf97c3f8b442424b9030000004083c50483c30483c604894424243b4424407c878b4c
            24188b74241c8b7c24608b5c24408b4424200374244840034c244ce92fffffff8b7c24608b4424508b5c24104f897c24603b
            f80f8d0cffffff8b6c24688b4c24148b7424284d03d9896c2468895c24103b6c24540f8ddbfeffffe95b01000083f8040f85
            520100008b6c2454896c24683b6c245c0f8d400100008b4424488b7424588b5424648b4c24504e8bd80fafdd89742428895c
            24148bfe897c24603bf90f8cff00000033c08bf38b5c244033c98974241c894c2418894424203b4424440f8da9fcffff33c0
            8944242485db0f8e9a0000008b5c243c8be903d98d34beb90300000090803c1900745f8b4424380fb64c06028b44243c0fb6
            7c28028d04113bf87f7c2bca3bf97c768b4424380fb64c06018b44243c0fb67c28018d04113bf87f5d2bca3bf97c578b4424
            380fb63b0fb604068d0c103bf97f452bc23bf87c3f8b442424b9030000004083c50483c30483c604894424243b4424407c87
            8b4c24188b74241c8b7c24608b5c24408b4424200374244840034c244ce930ffffff8b7c24608b4c24508b5c24144f897c24
            603bf90f8d0dffffff8b4424488b6c24688b7424284503d8896c2468895c24143b6c245c0f8cdefeffff8b4424305fc700ff
            ffffff8b4424305e5dc700ffffffff83c8ff5b83c41cc3,4c894c24204c89442418488954241048894c240853564883e
            c484c8b9424c00000008b9c24880000008bb4248000000041803a004d8bd9750e41807a0100750741807a0200745f85db7e5
            b4c8b4424784c639c24980000004c8bcb49ffc0669085f67e35498bc8488bd6660f1f440000410fb642023841017516410fb
            642013801750d410fb6023841ff7504c64102004883c10448ffca75d74d03c349ffc975bf4c8b5c24788b8424d0000000488
            96c244048897c24384c896424304c896c24284c897424204c897c241883f8010f85bc010000448b8424a800000044898424d
            0000000443b8424b80000000f8dba060000448ba424900000008b9424c80000008b8c24b0000000448b8c24a0000000418bc
            4410fafc0898424c00000006690458be9443bc90f8d1a010000468d3c8d00000000666666660f1f84000000000033ed448bf
            033ff3beb0f8d2401000033db85f60f8e94000000418bf7448bcf2bf74103f6666666660f1f8400000000004d63c14d03c34
            180780300745a450fb65002428d040e4c63d84c035c2470410fb64b028d0411443bd07f6a2bca443bd17c63410fb64b01450
            fb650018d0411443bd07f512bca443bd17c4a410fb60b450fb6108d0411443bd07f3a2bca443bd17c334c8b5c2478ffc3418
            3c1043b9c24800000007c8a8bb424800000008b9c2488000000ffc54503f403bc2498000000e942ffffff8b8c24b00000008
            b8424c00000008bb424800000004c8b5c24788b9c248800000041ffc54183c704443be90f8c0affffff448b8424d00000004
            48b8c24a000000041ffc04103c444898424d0000000898424c0000000443b8424b80000000f8d430500004c8b5c2478e9adf
            effff488b442460488b4c24684489288b8424d0000000890133c0e93505000083f8020f859f0100008b9424b8000000ffca8
            99424d00000003b9424a80000000f8cf6040000448ba42490000000448b8424c8000000448b8c24a00000008bc2418bcc410
            fafc4f7d9898c24c00000008b8c24b0000000890424448b9424c0000000458be9443bc90f8d14010000468d3c8d000000006
            6660f1f84000000000033ed448bf033ff3beb0f8d54ffffff33db85f60f8e8d000000418bf7448bd72bf74103f64963d2490
            3d3807a03007460440fb64a02428d04164c63d84c035c2470410fb64b02428d0401443bc87f6f412bc8443bc97c67410fb64
            b01440fb64a01428d0401443bc87f54412bc8443bc97c4c410fb60b440fb60a428d0401443bc87f3b412bc8443bc97c334c8
            b5c2478ffc34183c2043b9c24800000007c858bb424800000008b9c2488000000ffc54503f403bc2498000000e949ffffff8
            b8c24b00000008b04248bb424800000004c8b5c24788b9c248800000041ffc54183c704443be90f8c15ffffff8b9424d0000
            000448b8c24a0000000448b9424c0000000ffca4103c2899424d00000008904243b9424a80000000f8c7e0300004c8b5c247
            8e9bafeffff83f8030f85c10100008b9424b8000000ffca899424d00000003b9424a80000000f8c4e030000448bac2490000
            000448b9424b0000000448b8424c800000041ffca8bc2418bcd4489542404410fafc5f7d9890424898c24c00000008b8c24a
            0000000448b8c24c0000000458be2443bd10f8c11010000468d3c950000000066660f1f84000000000033ed448bf033ff3be
            b0f8d1601000033db85f60f8e8d000000418bf7448bd72bf74103f64963d24903d3807a03007460440fb64a02428d04164c6
            3d84c035c2470410fb64b02428d0401443bc87f6f412bc8443bc97c67410fb64b01440fb64a01428d0401443bc87f54412bc
            8443bc97c4c410fb60b440fb60a428d0401443bc87f3b412bc8443bc97c334c8b5c2478ffc34183c2043b9c24800000007c8
            58bb424800000008b9c2488000000ffc54503f503bc2498000000e949ffffff8b8c24a00000008b04248bb424800000004c8
            b5c24788b9c248800000041ffcc4183ef04443be10f8d15ffffff8b9424d0000000448b8c24c0000000448b542404ffca410
            3c1899424d00000008904243b9424a80000000f8cd10100004c8b5c2478e9bdfeffff488b442460488b4c24684489208b842
            4d0000000890133c0e9c301000083f8040f85a1010000448b8424a800000044898424d0000000443b8424b80000000f8d830
            10000448ba42490000000448b8c24b00000008b9424c80000008b8c24a000000041ffc9418bc444894c2404410fafc089842
            4c00000000f1f00458be9443bc90f8c17010000468d3c8d00000000666666660f1f84000000000033ed448bf033ff3beb0f8
            de4fbffff33db85f60f8e94000000418bf7448bcf2bf74103f6666666660f1f8400000000004d63c14d03c34180780300745
            a450fb65002418d04314c63d84c035c2470410fb64b028d0411443bd07f6a2bca443bd17c63410fb64b01450fb650018d041
            1443bd07f512bca443bd17c4a410fb603450fb6108d0c10443bd17f3a2bc2443bd07c334c8b5c2478ffc34183c1043b9c248
            00000007c8a8bb424800000008b9c2488000000ffc54503f403bc2498000000e942ffffff8b8c24a00000008b8424c000000
            08bb424800000004c8b5c24788b9c248800000041ffcd4183ef04443be90f8d0affffff448b8424d0000000448b4c240441f
            fc04103c444898424d0000000898424c0000000443b8424b80000007d0a4c8b5c2478e9b4feffff488b442460488b4c2468c
            700ffffffffc701ffffffff83c8ff4c8b7c24184c8b7424204c8b6c24284c8b642430488b7c2438488b6c24404883c4485e5bc3
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

    ; I don't quite remember if these were really necessary,
    ; but commenting them doesn't seem to affect anything.
    ;sx2 += !sx2
    ;sy2 += !sy2

    ; The DllCall parameters are the same for easier C code modification,
    ; even though they aren't all used on the _ImageSearch version
    x := 0, y := 0
    , E := DllCall( &_ImageSearch, "int*",x, "int*",y, Ptr,hScan, Ptr,nScan, "int",nWidth, "int",nHeight
    , "int",hStride, "int",nStride, "int",sx1, "int",sy1, "int",sx2, "int",sy2, Ptr,&Trans, "int",Variation
    , "int",sd, "cdecl int")
    return (E = "") ? -1107 : E
}

;**********************************************************************************
;
; Gdip_MultiLockedBitsSearch(), previously called Gdip_ImageSearchList()
; by MasterFocus - 23/MARCH/2013 02:00h BRT
; Requires GDIP and Gdip_LockedBitsSearch()
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http://creativecommons.org/licenses/by-sa/3.0/
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
;
;**********************************************************************************

Gdip_MultiLockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride,nScan,nWidth,nHeight
,ByRef OutputList="",OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=0
,SearchDirection=1,Instances=0,LineDelim="`n",CoordDelim=",")
{
    OutputList := ""
    OutputCount := !Instances
    InnerX1 := OuterX1 , InnerY1 := OuterY1
    InnerX2 := OuterX2 , InnerY2 := OuterY2
    While (!(OutputCount == Instances) && !Gdip_LockedBitsSearch(hStride,hScan,hWidth,hHeight,nStride
    ,nScan,nWidth,nHeight,FoundX,FoundY,OuterX1,OuterY1,OuterX2,OuterY2,Variation,Trans,SearchDirection))
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
        ,nScan,nWidth,nHeight,FoundX,FoundY,InnerX1,InnerY1,InnerX2,InnerY2,Variation,Trans,SearchDirection))
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