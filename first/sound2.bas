WHILE 1 
 FOR c = 0 TO 40 
 WAIT 
 SOUND 0,,0 
 SOUND 1,,0 
 SOUND 2,,0 
 NEXT c 
 FOR c = 0 TO 20 
 WAIT 
 SOUND 0,254-c*5,10-c/2 
 SOUND 1,127+c*3,10-c/2 
 SOUND 2,508-c*10,10-c/2 
 NEXT c 
WEND 