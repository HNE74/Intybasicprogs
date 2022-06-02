' Example 1 
 CLS ' Clears the screen
 DEFINE 5,1,smiling_face ' Define card 5 as a smiling face 
 c = 0 
 d = 1
 cl = 1
 
main_loop: 
 #backtab(c) = ($0800 + cl) + 5 * 8 ' Place it on the screen 
 WAIT ' Wait for a frame 
 WAIT ' Wait for a frame 
 WAIT ' Wait for a frame 
 WAIT ' Wait for a frame 
 WAIT ' Wait for a frame 
 #backtab(c) = 0 ' Remove it from the screen 
 c = c + d ' Increase value of c by 1 
 IF c = 10 or c=0 THEN d =-d  ' If c equals 240 then make it zero
 cl=cl+1
 IF cl = 8 THEN cl = 1 
 GOTO main_loop 
 
smiling_face: 
 BITMAP "..XXXX.." 
 BITMAP ".X....X." 
 BITMAP "X.X..X.X" 
 BITMAP "X......X"
 BITMAP "X.X..X.X" 
 BITMAP "X..XX..X" 
 BITMAP ".X....X." 
 BITMAP "..XXXX.."