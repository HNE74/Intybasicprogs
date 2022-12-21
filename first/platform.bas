

	REM stickman

 	
prets:
	mode 0,9,9,9,9

	wait
	define 50,4,drawings
	wait
	define 63,1,grass
	wait
	define 54,1,hole
	wait

	sprite 1,200+$700,96+$300,(256+53)*16+9 

	stickx=10 : sticky=84 
	cloudpos=39
	grasspos=0
	scrollt=0
	anim=50
	move=0
	jump=0
	level1length=0
	holex=200 : holey=96

	print at 4 color 2, "STICKMAN!"
	print at 220 color 5,"\319\319\319\319\319\319\319\319\319\319\319\319\319\319\319\319\319\319\319\319"

	gosub getgrass

	
titlescreenloop:


	if sticky>110 then goto prets
	if (holex<168) then sprite 1,holex+$700,96+$300,(256+53)*16+9 
	
	move=0

	argh=cont1
	
	if (argh>0) then print at 4 color 5, "         "

	if (anim>53) then anim=50

	if (cont1.button) and (jump=0) then play jumptune : jump=1 
	if (cont1.button=0) and (jump=1) then play falltune : jump=2



		WAIT

	 holexplus=holex+6 
	 holexminus=holex-6

	if (jump=1) then sticky=sticky-1
	if (sticky<50) and (jump=1) then play falltune : jump=2
	if (jump=2) then  sticky=sticky+1
 	if (sticky=84) and (jump=2) then jump=0

	if (flip=0) then sprite 0,stickx+$700,sticky+$200,(256+anim)*8+0 
	if (flip=1) then sprite 0,stickx+$700,sticky+$600,(256+anim)*8+0 
	
	if COL0 and $2 then goto titlescreenloop2

	goto titlescreenloop4

titlescreenloop2:
	if holexminus>stickx then goto titlescreenloop3
	sticky=sticky+1 : jump=2

titlescreenloop3:
	if holexplus>stickx then goto titlescreenloop4
	sticky=sticky+1 : jump=2

titlescreenloop4:
	if (argh=$18) OR (argh=$78) or (argh=$D8) OR (argh=$38) or (argh=$B8) THEN move=2 : flip=1
	if (argh=9) OR (argh=$69) or (argh=$C9) OR (argh=$29) or (argh=$A9) THEN move=2 : flip=1
	if (argh=8) OR (argh=$68) or (argh=$C8) or (argh=$28) or (argh=$A8) THEN move=2 : flip=1
	if (move=2) and (stickx=10) then move=0
	if (move=2) and (stickx>10) then stickx=stickx-1 : animtimer=animtimer+1
	

	if (argh=$12) OR (argh=$78) or (argh=$D2) OR (argh=$32) or (argh=$B2) THEN move=1 : flip=0
	if (argh=6) OR (argh=$68) or (argh=$C6) OR (argh=$26) or (argh=$a6) THEN move=1 : flip=0
	if (argh=2) OR (argh=$62) or (argh=$C2) or (argh=$22) or (argh=$A2) THEN move=1 : flip=0

	if (move=1) and (stickx<70) then stickx=stickx+1 : animtimer=animtimer+1 
	if (move=1) and (stickx>69) then scrollt=scrollt+1 : grasspos=grasspos+1 : gosub getgrass
 
	if (move=2) then scrollt2=scrollt2+1

	if (animtimer=8) then animtimer=0 : anim=anim+1

	if (scrollt2=8) then scrollt2=0 : anim=anim+1 
	if (scrollt=8) and (stickx>69) then anim=anim+1 : scrollt=0 





	goto titlescreenloop

getgrass: procedure

	if grasspos=4 then grasspos=0

	if grasspos=0 then define 63,1,grass4
	if grasspos=1 then define 63,1,grass3
	if grasspos=2 then define 63,1,grass2
	if grasspos=3 then define 63,1,grass  

	if holex=0 then holey=200
	if holey>199 then holey=199 : level1length=level1length+1

	if level1length=0 and holex=200 then holex=167 : holey=96
	if level1length=4 and holey=200 then holex=167 : holey=96
	
	if (holex<168) then sprite 1,holex+$700,96+$300,(256+53)*16+9 	

	if level1length=0 then holex=holex-1
	if level1length=4 then holex=holex-1


	


	return

	end


jumptune:	DATA 2
		MUSIC C5,-
		MUSIC C5#,-
		MUSIC D5,-
		MUSIC D5#,-
		MUSIC E5,-
		MUSIC STOP

falltune:	DATA 2
		MUSIC E5,-
		MUSIC D5#,-
		MUSIC D5,-
		MUSIC C5#,-
		MUSIC C5,-
		MUSIC STOP


drawings:
	BITMAP "00011000"
	BITMAP "00100100"
	BITMAP "00011000"
	BITMAP "00010010"
	BITMAP "00111100"
	BITMAP "01011000"
	BITMAP "00010100"
	BITMAP "00010010"

	BITMAP "00011000"
	BITMAP "00100100"
	BITMAP "00011000"
	BITMAP "00010000"
        BITMAP "00111110"
        BITMAP "00010000"
        BITMAP "00010000"
        BITMAP "00010000"

	BITMAP "00011000"
	BITMAP "00100100"
	BITMAP "00011000"
	BITMAP "01010000"
	BITMAP "00111100"
	BITMAP "00011010"
	BITMAP "00101000"
	BITMAP "01001000"

	BITMAP "00011000"
	BITMAP "00100100"
	BITMAP "00011000"
	BITMAP "00010000"
        BITMAP "00111110"
        BITMAP "00010000"
        BITMAP "00010000"
        BITMAP "00010000"

hole:
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"


grass:
	BITMAP "00100010"
	BITMAP "00100010"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"

grass2:
	BITMAP "00010001"
	BITMAP "00010001"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"

grass3:
	BITMAP "10001000"
	BITMAP "10001000"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"

grass4:
	BITMAP "01000100"
	BITMAP "01000100"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"
	bitmap "11111111"


