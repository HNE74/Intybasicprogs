CLS 
 PRINT AT 22 COLOR 6,"Twinkle, Twinkle" 
 PRINT AT 44,"Little Star" 
 PRINT AT 182 COLOR 5,"Press controller" 
 PRINT AT 206,"to start" 
 DO 
 WAIT 
 c = CONT1 
 LOOP WHILE c 
 DO 
 WAIT 
 c = CONT1 
 LOOP WHILE c = 0 
 PLAY SIMPLE 
 PLAY twinkle_twinkle_little_star 
 CLS 
 WHILE 1 
 c = RANDOM(240) 
 PRINT AT c COLOR 7,"." 
 FOR d = 0 TO 20 
 WAIT 
 NEXT d 
 PRINT AT c," " 
 WEND 
twinkle_twinkle_little_star: 
DATA 20 
 MUSIC D4,-,- 
 MUSIC D4,-,- 
 MUSIC A4,-,- 
 MUSIC A4,-,- 
 MUSIC B4,-,- 
 MUSIC B4,-,- 
 MUSIC A4,-,- 
 MUSIC S,-,- 
 MUSIC G4,-,- 
 MUSIC G4,-,- 
 MUSIC F4#,-,- 
 MUSIC F4#,-,- 
 MUSIC E4,-,- 
 MUSIC E4,-,- 
 MUSIC D4,-,- 
 MUSIC S,-,- 
 MUSIC A4,-,- 
 MUSIC A4,-,- 
 MUSIC G4,-,- 
 MUSIC G4,-,- 
 MUSIC F4#,-,- 
 MUSIC F4#,-,- 
 MUSIC E4,-,- 
 MUSIC S,-,- 
 MUSIC A4,-,- 
 MUSIC A4,-,- 
 MUSIC G4,-,- 
 MUSIC G4,-,- 
 MUSIC F4#,-,- 
 MUSIC F4#,-,- 
 MUSIC E4,-,- 
 MUSIC S,-,- 
 MUSIC D4,-,- 
 MUSIC D4,-,- 
 MUSIC A4,-,- 
 MUSIC A4,-,- 
 MUSIC B4,-,- 
 MUSIC B4,-,- 
 MUSIC A4,-,- 
 MUSIC S,-,- 
 MUSIC G4,-,- 
 MUSIC G4,-,- 
 MUSIC F4#,-,- 
 MUSIC F4#,-,- 
 MUSIC E4,-,- 
 MUSIC E4,-,- 
 MUSIC D4,-,- 
 MUSIC S,-,- 
 MUSIC STOP