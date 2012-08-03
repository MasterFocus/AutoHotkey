;========================================================================
; 
; Function:     ImageSearchList
; Description:  Find and list multiple instances of a single image on screen
; Online Ref.:  http://www.autohotkey.com/forum/viewtopic.php?p=361474#361474
;
; Last Update:  09/Jun/2010 03:00
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Thanks to:    jethrow for original code/algorithm
;               http://www.autohotkey.com/forum/post-302703.html#302703
;
;========================================================================
;
; p_ImgStr [, p_StartX, p_StartY, p_EndX, p_EndY, p_CDelim, p_LDelim, p_DebugFunc]
;
; + Required parameters:
; - p_ImgStr       ImageSearch's file string (containing options, if any)
;
; + Optional parameters:
; - p_StartX       Initial X coordinate (default is 0)
; - p_StartY       Initial Y coordinate (default is 0)
; - p_EndX         Final X coordinate (default is 0, uses A_ScreenWidth)
; - p_EndY         Final Y coordinate (default is 0, uses A_ScreenHeight)
; - p_CDelim       Coordinate delimiter of the output list (default is ",")
; - p_LDelim       Line delimiter of the output list (default is "`n")
; - p_DebugFunc    A debug function's name (literal string, default is blank)
;
; The function returns a list of distinct positions (X and Y coordinates)
; where the specified image was found (according to the options, if any).
;
; A debug function can be created to retrieve further information on every
; iteration the image is searched. The parameters for this function are:
; - The number of the current iteration
; - ImageSearch's output X coordinate
; - ImageSearch's output Y coordinate
; - The starting X coordinate where the search was conducted
; - The starting Y coordinate where the search was conducted
; - The final X coordinate where the search was conducted
; - The final Y coordinate where the search was conducted")
; - The ImageFile string that was used (always the same as p_ImgStr)
; - The current list of matching coordinates
;
;========================================================================

ImageSearchList(p_ImgStr,p_StartX=0,p_StartY=0,p_EndX=0,p_EndY=0,p_CDelim=",",p_LDelim="`n",p_DebugFunc="")
{
  l_Debug := IsFunc(p_DebugFunc) , l_StX := p_StartX , l_List := ""
  p_EndX := ( !p_EndX ? A_ScreenWidth : p_EndX ) , p_EndY := ( !p_EndY ? A_ScreenHeight : p_EndY )
  Loop
  {
    ImageSearch, l_OutX, l_OutY, %l_StX%, %p_StartY%, %p_EndX%, %p_EndY%, %p_ImgStr%
    If l_Debug
      %p_DebugFunc%(A_Index,l_OutX,l_OutY,l_StX,p_StartY,p_EndX,p_EndY,p_ImgStr,l_List)
    If InStr( l_List , l_OutX p_CDelim l_OutY p_LDelim )
    {
      l_StX := l_OutX+1
      Continue
    }   
    If ( l_OutX="" || l_OutY="" )
      If ( l_StX <> p_StartX )
      {
        l_StX := p_StartX , p_StartY++
        Continue
      }
      Else
        Break
    l_List .= l_OutX p_CDelim ( p_StartY := l_OutY ) p_LDelim
  }
  Return l_List
}