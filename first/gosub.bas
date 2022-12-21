
	WAIT
	define 16,15,tiles
	wait
	DEFINE 0,2,submarine
	

prets:
	room=0
	x1=0
	y1=47
	soundtimer=1
	wait
	cls
	SPRITE 1,0,0
	PRINT AT 0 COLOR 5,"        GoSub       "
	PRINT AT 220 COLOR 4,"  2015, Chris Read  "

titlescreenloop:
	WAIT
	soundtimer=soundtimer+1
	if soundtimer>220 then sound 0,100,15 
	if soundtimer=255 then soundtimer=0 : sound 0,,0
        SPRITE 0,X1+$300,Y1+$100,$1800
	x1=x1+1
	if x1>200 then x1=0
	if cont1.button then sound 0,,0 : goto maze1
	GOTO titlescreenloop

maze1:
	dir=0	
	subtimer=0
	x1=22
	y1=78
	wait
	cls

	if room=0 then restore room0

	print at 0 color 6,"     level one      "

        print color 4
        for y=0 to 11
        read #line
        for x=0 to 19
        if #line and $8000 then print at y*20+x,"\272"
        #line = #line * 2
        next 
        next


mazemain:
        SPRITE 1,44+$300,44+$100,$180b
	sprite 0,X1+$300,Y1+$100,$1800
	if COL0 AND $2 then goto prets
        IF COL0 AND $011e THEN GOTO maze1
	if cont1.left then dir=1
 	if cont1.right then dir=2
 	if cont1.up then dir=3
	if cont1.down then dir=4
	wait
	if dir=0 then goto mazemain
	subtimer=subtimer+1
	if subtimer<2 then goto mazemain
	subtimer=0
	if dir=1 then x1=x1-1
	if dir=2 then x1=x1+1
	if dir=3 then y1=y1-1
	if dir=4 then y1=y1+1
	if y1>87 then y1=18
	if y1<18 then y1=87
	if x1>160 then x1=8
	if x1<8 then x1=160
	goto mazemain


room0:
        DATA $0000,$ffff,$8001,$8fff,$8061,$8061
        DATA $8061,$8021,$87E1,$8001,$ffff,$0000

submarine:
	BITMAP "00001100"
	BITMAP "00010000"
	BITMAP "00010000"
	BITMAP "01111110"
	BITMAP "11111111"
	BITMAP "11010101"
	BITMAP "11111111"
	BITMAP "01111110"

	BITMAP "...#####"
	BITMAP "..#...##"
	BITMAP ".#...#.#"
	BITMAP "######.#"
	BITMAP "#....###"
	BITMAP "######.#"
	BITMAP "#....#.#"
	BITMAP "#######."
	

tiles:
	BITMAP "00001000"
	BITMAP "00010001"
	BITMAP "11101110"
	BITMAP "00110001"
	BITMAP "10001000"
	BITMAP "01110001"
	BITMAP "00001110"
	BITMAP "00010000"
