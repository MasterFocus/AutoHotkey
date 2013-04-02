/**********************************************************************************
// Latest C code used to generate the MCode used in Gdip_LockedBitsSearch()
// by MasterFocus, based on original work by tic and Rseding91
// Last modification: 24/MARCH/2013 06:20h BRT
//
// Licensed under CC BY-SA 3.0: http://creativecommons.org/licenses/by-sa/3.0/
// I waive compliance with the "Share Alike" condition of the license
// exclusively for the following users: tic, Rseding91, guest3456
//
// http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
// http://www.github.com/MasterFocus/
**********************************************************************************/

int Gdip_ImageSearch(int * Foundx, int * Foundy, unsigned char * HayStack, unsigned char * Needle, int nw, int nh, int Stride1, int Stride2, int sx1, int sy1, int sx2, int sy2, int v, int sd)
{
    int y1, y2, x1, x2, idxN, idxH;
    if ( sd == 1 ) { // [default] top->left->right->bottom (vertical preference)
        for (y1 = sy1; y1 < sy2; y1++) {
            for (x1 = sx1; x1 < sx2; x1++) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch1;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch1:;
            }
        }
    }
    else if ( sd == 2 ) { // bottom->left->right->top (vertical preference)
        for (y1 = sy2-1; y1 >= sy1; y1--) {
            for (x1 = sx1; x1 < sx2; x1++) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch2;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch2:;
            }
        }
    }
    else if ( sd == 3 ) { // bottom->right->left->top (vertical preference)
        for (y1 = sy2-1; y1 >= sy1; y1--) {
            for (x1 = sx2-1; x1 >= sx1; x1--) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch3;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch3:;
            }
        }
    }
    else if ( sd == 4 ) { // top->right->left->bottom (vertical preference)
        for (y1 = sy1; y1 < sy2; y1++) {
            for (x1 = sx2-1; x1 >= sx1; x1--) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch4;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch4:;
            }
        }
    }
    if ( sd == 5 ) { // [default] left->top->bottom->right (horizontal preference)
        for (x1 = sx1; x1 < sx2; x1++) {
            for (y1 = sy1; y1 < sy2; y1++) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch5;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch5:;
            }
        }
    }
    else if ( sd == 6 ) { // left->bottom->top->right (horizontal preference)
        for (x1 = sx1; x1 < sx2; x1++) {
            for (y1 = sy2-1; y1 >= sy1; y1--) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch6;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch6:;
            }
        }
    }
    else if ( sd == 7 ) { // right->bottom->top->left (horizontal preference)
        for (x1 = sx2-1; x1 >= sx1; x1--) {
            for (y1 = sy2-1; y1 >= sy1; y1--) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch7;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch7:;
            }
        }
    }
    else if ( sd == 8 ) { // right->top->bottom->left (horizontal preference)
        for (x1 = sx2-1; x1 >= sx1; x1--) {
            for (y1 = sy1; y1 < sy2; y1++) {
                for (y2 = 0; y2 < nh; y2++) {
                    for (x2 = 0; x2 < nw; x2++) {
                        idxN = (4*x2)+(y2*Stride2); // needle index offset
                        idxH = (4*(x1+x2))+((y1+y2)*Stride1); // haystack index offset
                        if ( !( Needle[idxN+3] == 0
                        ||      Needle[idxN+2] <= HayStack[idxH+2]+v
                        &&      Needle[idxN+2] >= HayStack[idxH+2]-v
                        &&      Needle[idxN+1] <= HayStack[idxH+1]+v
                        &&      Needle[idxN+1] >= HayStack[idxH+1]-v
                        &&      Needle[idxN+0] <= HayStack[idxH+0]+v
                        &&      Needle[idxN+0] >= HayStack[idxH+0]-v ) )
                            goto NoMatch8;
                    }
                }
                Foundx[0] = x1; Foundy[0] = y1;
                return 0;
                NoMatch8:;
            }
        }
    }
    Foundx[0] = -1; Foundy[0] = -1;
    return -4001;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**********************************************************************************
// Latest C code used to generate the MCode used in Gdip_SetBitmapTransColor()
// by MasterFocus, based on original work by tic and Rseding91
// Last modification: 02/APR/2013 00:15 BRT
//
// Licensed under CC BY-SA 3.0: http://creativecommons.org/licenses/by-sa/3.0/
// I waive compliance with the "Share Alike" condition of the license
// exclusively for the following users: tic, Rseding91, guest3456
//
// http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
// http://www.github.com/MasterFocus/
**********************************************************************************/

int Gdip_SetBitmapTransColor(unsigned char * Scan, int Width, int Height, int Stride, unsigned char * Trans, int * MCount)
{
    int x1, y1, index;
    MCount[0] = 0;
    for (y1 = 0; y1 < Height; y1++) {
        for (x1 = 0; x1 < Width; x1++) {
            // using index to calculate the needle index offset only once
            index = (4*x1)+(y1*Stride);
            if ( Scan[index+2] == Trans[2]
            &&   Scan[index+1] == Trans[1]
            &&   Scan[index+0] == Trans[0] ) {
                Scan[index+3] = 0;
                MCount[0]++;
            }
        }
    }
    return 0;
}