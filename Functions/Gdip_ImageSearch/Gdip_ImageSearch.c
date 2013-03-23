/**********************************************************************************
// Latest C code used to generate the MCode required to perform a GDIP ImageSearch
// by MasterFocus, based on original work by tic and Rseding91
// Last modification: 23/MAR/2013 02:00 BRT
//
// Licensed under CC BY-SA 3.0: http://creativecommons.org/licenses/by-sa/3.0/
// I waive compliance with the "Share Alike" condition of the license
// exclusively for the following users: tic, Rseding91, guest3456
//
// http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
// http://www.github.com/MasterFocus/
**********************************************************************************/

int Gdip_ImageSearch(int * Foundx, int * Foundy, unsigned char * HayStack, unsigned char * Needle, int nw, int nh, int Stride1, int Stride2, int sx1, int sy1, int sx2, int sy2, unsigned char * Trans, int v, int sd)
{
    int y1, y2, x1, x2, idxN, idxH;

    // Make all needle pixels matching the Trans color fully transparent (opacity = 0)
    if ( Trans[0] || Trans[1] || Trans[2] ) {
        for (y1 = 0; y1 < nh; y1++) {
            for (x1 = 0; x1 < nw; x1++) {
                // using idxN to calculate the needle index offset only once
                idxN = (4*x1)+(y1*Stride2);
                if ( Needle[idxN+2] == Trans[2]
                &&   Needle[idxN+1] == Trans[1]
                &&   Needle[idxN+0] == Trans[0] )
                    Needle[idxN+3] = 0;
            }
        }
    }

    if ( sd == 1 ) { // [default] top->bottom, left->right
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
    else if ( sd == 2 ) { // bottom->top, left->right
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
    else if ( sd == 3 ) { // bottom->top, right->left
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
    else if ( sd == 4 ) { // top->bottom, right->left
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
    Foundx[0] = -1; Foundy[0] = -1;
    return -1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////