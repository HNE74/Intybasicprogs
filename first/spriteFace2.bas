CLS ' Clears the screen 
 DEFINE 5,1,smiling_face' Define card as a smiling face 
 x = 84 
 y = 52 
main_loop: 
 SPRITE 0, $0300 + x, $0100 + y, $0807 + 5 * 8 
 WAIT ' Wait for a frame 
 IF cont1.up THEN y = y - 1 
 IF cont1.down THEN y = y + 1 
 IF cont1.left THEN x = x - 1 
 IF cont1.right THEN x = x + 1 
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
