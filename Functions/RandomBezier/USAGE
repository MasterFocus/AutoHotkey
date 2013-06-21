========================================================================

 X0, Y0, Xf, Yf [, O]

 + Required parameters:
 - X0 and Y0     The initial coordinates of the mouse movement
 - Xf and Yf     The final coordinates of the mouse movement

 + Optional parameters:
 - O             Options string, see remarks below (default: blank)

 It is possible to specify multiple (case insensitive) options:

 # "Tx" (where x is a positive number)
   > The time of the mouse movement, in miliseconds
   > Defaults to 200 if not present
 # "RO"
   > Consider the origin coordinates (X0,Y0) as relative
   > Defaults to "not relative" if not present
 # "RD"
   > Consider the destination coordinates (Xf,Yf) as relative
   > Defaults to "not relative" if not present
 # "Px" or "Py-z" (where x, y and z are positive numbers)
   > "Px" uses exactly 'x' control points
   > "Py-z" uses a random number of points (from 'y' to 'z', inclusive)
   > Specifying 1 anywhere will be replaced by 2 instead
   > Specifying a number greater than 19 anywhere will be replaced by 19
   > Defaults to "P2-5"
 # "OTx" (where x is a number) means Offset Top
 # "OBx" (where x is a number) means Offset Bottom
 # "OLx" (where x is a number) means Offset Left
 # "ORx" (where x is a number) means Offset Right
   > These offsets, specified in pixels, are actually boundaries that
     apply to the [X0,Y0,Xf,Yf] rectangle, making it wider or narrower
   > It is possible to use multiple offsets at the same time
   > When not specified, an offset defaults to 100
     - This means that, if none are specified, the random Bézier control
       points will be generated within a box that is wider by 100 pixels
       in all directions, and the trajectory will never go beyond that

========================================================================