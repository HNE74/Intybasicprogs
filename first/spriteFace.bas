' Example 1 
 CLS ' Clears the screen
 DEFINE 5,1,smiling_face ' Define card 5 as a smiling face 
 c = 0 
 
main_loop: 
 '                 x          y        
 SPRITE 0, $0300 + c, $0100 + 8, $0807 + 5 * 8 
 WAIT ' Wait for a frame 
 WAIT ' Wait for a frame 
 'WAIT ' Wait for a frame 
 'WAIT ' Wait for a frame 
 'WAIT ' Wait for a frame 
 c = c + 1 ' Increase value of c by 1 
 IF c = 168 THEN c = 0 ' If c equals 168 then make it zero 
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