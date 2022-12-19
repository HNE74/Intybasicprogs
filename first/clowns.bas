	REM
	REM Clowns and Balloons game
	REM Created in IntyBASIC
	REM by Catsfolly
	REM Feb 2014.
	REM 
	
REM *****************************************************************
REM
REM Title routine - displays the title page
REM
REM *****************************************************************
title:
	cls		' clear the screen
	
	REM disable the sprites
	SPRITE 0,0,0,0
	SPRITE 1,0,0,0
	SPRITE 2,0,0,0
	SPRITE 3,0,0,0
	SPRITE 4,0,0,0
	WAIT
	
    REM the screen is 20 chars wide so position is 20 * row + col
        print at (20* 3 + 5),"Clowns and"
        print at (20* 4 + 6),"Balloons"
  	print at (20* 5 + 8),"Beta"

	print at (20* 9 + 3) COLOR 1,"Created with"
	print at (20*10 + 3) COLOR 2,"IntyBasic 0.4"

	title_lp:
	REM loop until a button or the disc is pressed
	IF (cont1.button + cont1.left + cont1.right + cont1.up + cont1.down)=0 THEN GOTO title_lp

REM *****************************************************************
REM
REM RESET - start a new game
REM
REM *****************************************************************

RESET:
	
	WAIT
	DEFINE 0,20,gramchars ' load the custom character definitions
	WAIT
	DEFINE 20,20,gramchars2
	WAIT
	DEFINE 40,10,gramchars3
	
	round=1 ' start at round one
restart:
	lives=3	' 3 lives at the start

	rem the score is stored in BCD (Binary coded decimal) in 3 bytes
	rem s1 is the most significant byte
	s1=0
	s2=0
	s3=0

new_round:	' go here to start a new round
	cls
	WAIT
	SPRITE 0,0,0,0
	SPRITE 1,0,0,0
	SPRITE 2,0,0,0
	SPRITE 3,0,0,0
	SPRITE 4,0,0,0

  	print at (20 * 4 + 8) COLOR 7, "ROUND"
	PRINT AT (20 * 5 + 9),(round/100%10+16)*8+7,(round/10%10+16)*8+7,(round%10+16)*8+7
	for a=0 to 60 ' wait about a second
		WAIT
	NEXT a
	cls

	gosub init_clown
	red1 = 0	' if nonzero, the stretcher carriers turn red
	red2 = 0
	bounces=0	' count the bounces
	saf = 0		' stretcher animation freme
	X = 80		' stretcher x position
	ground_hit=0 ' if one, the clown has hit the ground

	GOSUB display_score		' draw the score and bounces and lives
	GOSUB init_balloons3	' init the balloons for this round
	for A=0 to 20			' draw a line across the screen dividing game and hud
		poke ($200 + (10 * 20)) +a, (49 *8) + $0804
	next a

REM *****************************************************************
REM
REM loop - main gameplay loop
REM
REM *****************************************************************
loop:	
	WAIT
	GOSUB draw_stretcher
   
	REM SPRITE 4 is the clown
	af = 12	' chose a picture 12 is floating, 14 is rising, 16 is falling
	IF #cyv < -10 THEN af = 14 ELSE if #cyv > 10 THEN af = 16
	SPRITE 4,(#cx/16) + $300+8 ,(#cy / 16) +$080,$0806 + (af * 8)

	IF saf > 0 THEN saf = saf -1	' animate the stretcher 
	GOSUB move_player				' move the stretcher
    GOSUB move_clown				' move the clown, collide with balloons, stretcher and ground
	GOSUB display_score				' draw the score and bounces and lives
	GOSUB update_balloons			' animate exploding balloons, count balloons
	
	rem if the balloon count is complete and the count is zero, go to round finished code
	if ((frame AND 3)=3) AND (balloon_count=0) GOTO did_it
	
	if ground_hit=0 GOTO loop	' if we didn't hit the ground, go back to loop
REM main gameplay loop end *****************************************************************	


rem clown death sequence	
	bf = 38	' animation frame for flying dust sprite
	rem ground hit sound
	SOUND 0,$333,8 ' freq and vol
	SOUND 3,$73f,0 ' evelope duration
	POKE $01fB,$38 ' use envelope

ground_loop:
	
	WAIT
	    if af > 37 THEN SPRITE 5,0 ,0,0: goto do_4
		SPRITE 5,(#cx/16) + $300+8 ,(#cy / 16) +$080,$0806 + (af * 8)
do_4:
		SPRITE 4,(#cx/16) + $300+8 ,(#cy / 16) +$100,$0804 + (bf * 8)
		if (FRAME AND 7) = 7 THEN af=af+2:bf= bf+1
		GOSUB draw_stretcher
		GOSUB move_player


		if(af < 48) GOTO ground_loop
		for a=0 to 60
		WAIT
		SPRITE 4,0 ,0,0
			SPRITE 5,0 ,0,0
			GOSUB draw_stretcher
		GOSUB move_player
		
	NEXT a
	lives = lives-1
	if (lives < 1) THEN goto game_over
	GOSUB init_clown
	GOTO loop
REM *****************************************************************
REM
REM game_over - display game over message, give a chance to continue
REM
REM *****************************************************************	
game_over:

	WAIT
	
  	print at (20 * 6 + 5) COLOR 7, "GAME OVER"
	 for a=0 to 120
		WAIT
	NEXT a
	continue=9
	print at (20 * 7 + 5) COLOR 6, "CONTINUE?"
pre_loop:
	if (frame AND $3f)> 0 goto pre_loop

game_over_loop:
	WAIT
	print at (20 * 8 + 9),(continue+16)*8+6
	if (frame AND $3f)=$3f THEN continue=continue-1
	
	IF (cont1.button + cont1.left + cont1.right + cont1.up + cont1.down)>0 THEN  GOTO restart
	if (continue>0) GOTO game_over_loop
	goto title
REM *****************************************************************
REM
REM did it - display finished round message
REM
REM *****************************************************************	
did_it:
	cls
	WAIT
	SPRITE 0,0,0,0
	SPRITE 1,0,0,0
	SPRITE 2,0,0,0
	SPRITE 3,0,0,0
	SPRITE 4,0,0,0

  	print at (20 * 2 + 8) COLOR 7, "ROUND"
	PRINT AT (20 * 3 + 9),(round/100%10+16)*8+7,(round/10%10+16)*8+7,(round%10+16)*8+7
	print at (20 * 4 + 6),"COMPLETE!"
	
	print at (20 * 7 + 7) COLOR 2, "BOUNCES"
	PRINT at (20 * 8 + 9),(bounces/100%10+16)*8+6,(bounces/10%10+16)*8+6,(bounces%10+16)*8+6
	if (bounces < 30) THEN poke ($200 + (20 * 9) +  7), $800 + (48 * 8) + 6
	if (bounces < 23) THEN poke ($200 + (20 * 9) + 10), $800 + (48 * 8) + 6
	if (bounces < 15) THEN poke ($200 + (20 * 9) + 13), $800 + (48 * 8) + 6
	 
	 for a=0 to 120
		WAIT
	NEXT a
	
did_it_loop:
	IF (cont1.button + cont1.left + cont1.right + cont1.up + cont1.down)=0 THEN GOTO did_it_loop
	
	round= round+1: GOTO new_round
	

REM *****************************************************************
REM
REM add_points - adds point to the score, points must be in bcd format
REM
REM *****************************************************************

add_points: PROCEDURE
	rem temp has the points (must be less than 100
	temp2 = s3+ temp
	carry= 0
	gosub fix_bcd
	s3=temp2
	if (carry>0) THEN temp2=s2: gosub fix_bcd:s2=temp2
	if (carry>0) THEN temp2=s1: gosub fix_bcd:s1=temp2
	RETURN
	END
	
fix_bcd: PROCEDURE
	rem value in temp2, read/set carry
	if carry>0 THEN temp2=temp2+1: carry=0
	if ((temp2 AND $0f) > 9) THEN temp2= temp2+6
	if (temp2 > $99) THEN temp2 = (temp2+ $060) AND $00ff: carry=1
	RETURN
	END
REM *****************************************************************
REM
REM display score - draw the score and bounces and lifes
REM
REM *****************************************************************
display_score:	PROCEDURE

	rem print lives
	PRINT at (20 * 11 + 17) COLOR 2,"L:",(lives+15)*8+6
	
	rem print bounces
	PRINT AT (20 * 11 + 10) COLOR 2,"B:"
	IF bounces < 10 THEN PRINT (bounces+16)*8+6 : goto ds_done
	IF bounces < 100 THEN PRINT (bounces/10%10+16)*8+6,(bounces%10+16)*8+6 : GOTO ds_done
	PRINT (bounces/100%10+16)*8+6,(bounces/10%10+16)*8+6,(bounces%10+16)*8+6
ds_done:

	rem print score
	PRINT AT (20 * 11) COLOR 2,"S:"
	
	if (s1=0 ) GOTO ds_trys2
	if (s1> 9) THEN PRINT (s1/16 +16)*8+6
	PRINT ((s1 AND $0f)+16) *8+6
	PRINT (s2/16 +16)*8+6,((s2 AND $0f)+16) *8+6
	PRINT (s3/16 +16)*8+6,((s3 AND $0f)+16) *8+6
	RETURN
	
ds_trys2:
	if (s2= 0) GOTO ds_trys3 
	if (s2> 9) THEN PRINT (s2/16 +16)*8+6
	PRINT ((s2 AND $0f)+16) *8+6
	PRINT (s3/16 +16)*8+6,((s3 AND $0f)+16) *8+6
	RETURN
ds_trys3:
	if (s3> 9) THEN PRINT (s3/16 +16)*8+6
	PRINT ((s3 AND $0f)+16) *8+6
	
	
	RETURN
	END
REM *****************************************************************
REM
REM move_player - currently supports left control only
REM
REM *****************************************************************
move_player:	PROCEDURE
	IF cont1.left THEN  if (X > 8) THEN X=X-1 
	IF cont1.right THEN IF (X<128) THEN X=X+1

	RETURN
	END

REM *****************************************************************
REM
REM draw_stretcher - draw the stretcher and the carriers
REM
REM *****************************************************************
draw_stretcher:	PROCEDURE
 
    REM SPRITE 0 is the left stretcher holder
	temp = 0
	if red1 > 0 THEN red1 = red1-1: temp = (4 * 8) -5 ' add (4 *8) to choose pushed head animation, -5 changes color from white to red
	SPRITE 0,X + $300   ,84+$100,$0807 + ((X AND 3) * 8) + temp 
	 
	REM SPRITE 1 is the right stretcher holder
	temp = 0
	if red2 > 0 THEN red2 = red2-1: temp = (4 * 8) -5 ' add (4 *8) to choose pushed head animation, -5 changes color from white to red
	
	SPRITE 1,((X + 32) AND $0ff) + $300,84+$500,$0807+ ((3-(X AND 3)) * 8) + temp
	REM SPRITES 2 and 3 are the stretcher
	
	if saf = 0 THEN temp= (8 * 8) ELSE read temp
	
	SPRITE 2, $700+((X +  8) AND $0ff)  ,84+$100 + ((temp AND $80) * 16),$0801 + (temp and $7f)
	SPRITE 3, $700+((X + 16) AND $0ff)  ,84+$500 + ((temp AND $80) * 16),$0801 + (temp and $7f)
	RETURN

	REM if (X<9) AND (cont1.left>0) GOTO push_left
	REM if (X>127) AND (cont1.right>0) GOTO push_right


	END
	
REM *****************************************************************
REM
REM move_clown - move the clown, collide with ground, stretcher and balloons
REM
REM *****************************************************************
move_clown:	PROCEDURE
    REM check direction of movement
    IF (#cyv < 0) GOTO up

	REM check for collision with stretcher
	test = COL4 AND $00c
	IF test =0 GOTO staff
	REM if we get here we are moving down and hittng the stretcher
	
	if #cyv> 23 THEN #cyv=23 'limit y speed so we don't wrap around
	
	if (X<9) AND (cont1.left>0) THEN test=8     ' if player pushes  left, make the clown go right
	if (X>127) AND (cont1.right>0) THEN test=4  ' if player pushes right, make the clown go left
	
	if test=4  THEN #cyv = 0 - #cyv -2 : if #cxv<0 THEN #cxv = -5 ELSE #cxv = -2
	if test=12 then  #cyv = 0 - #cyv -4 : #cxv =  0 
	if test=8  then #cyv = 0 - #cyv -2 : if #cxv> 0 THEN #cxv = 5 ELSE #cxv =  2
	saf = 14
	RESTORE stretcher
	
	SOUND 0,$540 +(#cyv *16) ,8 ' was %540
	SOUND 3,$53f,0
	POKE $01fB,$38 ' use envelope
	bounces=bounces+1

	
	
	GOTO move

staff:	
	rem check collision with stretcher carriers
	test = COL4 AND 3
	if (test=0) THEN GOTO up
	#cyv = ((0 - #cyv) * 3 )/4
	if test=1 THEN red1=30:#cxv=-10
	if test=2 THEN red2=30:#cxv= 10
	
	rem robot head bounce sound
	SOUND 0,$140,8
	SOUND 3,$33f,0
	POKE $01fB,$38 ' use envelope
	if (bounces < 255) THEN bounces=bounces+1

	
	
	GOTO move

up:	
	rem going up so check ballon collisions
	if (COL4 AND $0100)=0 THEN GOTO move
	REM looks like a collision
	#val = ((#cy - (4 * 16)) / 8) AND $fff0
	#val = #val + (#val/4)
	#temp = #cx/16
	#temp = (#temp/8) + $200 + #val

	#val  = PEEK(#temp)
	if (#val AND $01F8) =(18*8) THEN GOTO DING
	#temp = #temp+1
	#val  = PEEK(#temp)
	if (#val AND $01F8) =(18*8) THEN  GOTO DING
	GOTO move
DING:
	POKE #temp,#val+8 ' start the balloon animation
	temp = 5
	GOSUB add_points
	
	SOUND 0,$060,8
	SOUND 3,$43f,0
	POKE $01fB,$38 ' use envelope

	
move:
	rem move the clown
    ground_hit=0
	IF ((FRAME AND 3)=1) THEN #cyv = #cyv +1 ' increase speed every 4th frame
	#cy  = #cy + #cyv
	#cx  = #cx + #cxv
	IF #cy > (86 *16) THEN ground_hit=1:af=28 ' was 87
	IF (#cx < 0) THEN #cx=0:if(#cxv<0) THEN #cxv = 0 - #cxv : GOTO wall_sound
        IF (#cx > (152 * 16)) THEN #cx=(152 * 16): IF (#cxv > 0) THEN #cxv = 0 - #cxv : goto wall_sound

	RETURN
wall_sound:

	rem wall bounce sound
	SOUND 0,$a80,8
	SOUND 3,$33f,0
	POKE $01fB,$38 ' use envelope
	
	RETURN
	END

REM *****************************************************************
REM
REM init_clown - put the clown in the center of the screen, no velocity
REM
REM *****************************************************************
init_clown: PROCEDURE
	#cx = 80 * 16
	#cy = 48 * 16
	#cxv = 0
	#cyv = 0
	RETURN
	END


REM *****************************************************************
REM
REM init_balloons3 - draw balloons for this round
REM
REM *****************************************************************	
init_balloons3: PROCEDURE

	for a=0 to 24
		temp = (round-1) % 10
		#temp = #bt_3( ((temp) * 25) + a)
		gosub do_a_word
	next a
		balloon_count = 1 ' init to nonzero value
	RETURN
	END
	
do_a_word: PROCEDURE	
	#value = #temp/16
	b8 = #value/16
	
	t2 = (b8/16) AND $0f
	if t2=0 GOTO daw_2
	#value = $800 + (8 * 18) + t2
	if (t2 > 7) THEN #value = #value + ($1000- 8)
	poke $200 + (a * 4), #value
daw_2:
	t2 = b8 AND $0f
	if t2=0 GOTO daw_3
	#value = $800 + (8 * 18) + t2 
	if (t2 > 7) THEN #value = #value + ($1000- 8)
	poke $200 + (a * 4)+1, #value
daw_3:
	t2 = (#temp/16) AND $0f
	if t2=0 GOTO daw_4
	#value = $800 + (8 * 18) + t2 
	if (t2 > 7) THEN #value = #value + ($1000- 8)
	poke $200 + (a * 4)+2, #value
daw_4:
	t2 = #temp AND $0f
	if t2=0 GOTO daw_5
	#value = $800 + (8 * 18) + t2 
	if (t2 > 7) THEN #value = #value + ($1000- 8)
	poke $200 + (a * 4)+3, #value
daw_5:
	
	RETURN
	END
	
REM *****************************************************************
REM
REM init_balloons3 - draw balloons for this round
REM the work is spread out over 4 frames 
REM
REM *****************************************************************		
	
update_balloons: PROCEDURE
  test= frame AND 3
  if (test) = 0 THEN balloon_count = 0
  start = (test * 16) + (test * 8) +test ' test * 25
  FOR A=start TO start+24 ' Loop
  #temp = PEEK($200 +A)		' read the screen location
  if #temp=0 THEN GOTO ub_next	' if zero, advance
  balloon_count = balloon_count+1	' if not zero, count it as a balloon
  if (#temp AND $01F8) =(18*8) GOTO ub_next	' if not exploding frame, go to next location
  if (#temp AND $01f8) > (25*8) THEN POKE ($200+A), 0: GOTO ub_next ' if animation is done, clear the location
  POKE ($200 + A), #temp + 8 ' advance to next animation frame


  ub_next:
  NEXT A
	RETURN
	END


rem stretcher animation - gram number * 8 plus $80 if we y flip the picture
stretcher:
data	10 * 8
data	10 * 8
data     9 * 8
data     9 * 8
data     8 * 8
data     8 * 8
data     9 * 8 + $80
data     9 * 8 + $80
data    10 * 8 + $80 
data    10 * 8 + $80
data     9 * 8 + $80
data     9 * 8 + $80 
data     8 * 8
data     8 * 8
data     9 * 8
data     8 * 8
data     8 * 8
data     8 * 8


REM			C_BLK   EQU     $0              ; Black
REM                     C_BLU   EQU     $1              ; Blue
REM                     C_RED   EQU     $2              ; Red
REM                     C_TAN   EQU     $3              ; Tan
REM                     C_DGR   EQU     $4              ; Dark Green
REM                     C_GRN   EQU     $5              ; Green
REM                     C_YEL   EQU     $6              ; Yellow
REM                     C_WHT   EQU     $7              ; White
REM                     C_GRY   EQU     $8              ; Grey
REM                     C_CYN   EQU     $9              ; Cyan
REM                     C_ORG   EQU     $A              ; Orange
REM                     C_BRN   EQU     $B              ; Brown
REM                     C_PNK   EQU     $C              ; Pink
REM                     C_LBL   EQU     $D              ; Light Blue
REM                     C_YGR   EQU     $E              ; Yellow-Green
REM                     C_PUR   EQU     $F              ; Purple

rem balloon tables - each digit is a color from the above table


#bt_3:
	REM round 1 (Nano)
	DATA $0011,$1022,$2011,$1033,$3000
	DATA $0010,$1020,$2010,$1030,$3000
	DATA $0010,$1022,$2010,$1030,$3000
	DATA $0010,$1020,$2010,$1033,$3000
	DATA $0000,$0000,$0000,$0000,$0000
	
	REM round 2 Curtains
	DATA $0511,$0000,$0000,$0000,$1150
	DATA $0451,$1111,$1111,$1111,$1540
	DATA $0045,$5555,$5555,$5555,$5400
	DATA $0004,$4444,$4444,$4444,$4000
	DATA $0000,$0000,$0000,$0000,$0000

	REM round 3 dz
	DATA $0009,$0777,$7000,$0999,$9900	
	DATA $0009,$0000,$7000,$9777,$7790
	DATA $0999,$0007,$0000,$9797,$9790
	DATA $0909,$0070,$0000,$9777,$7790
	DATA $0999,$0777,$7000,$9777,$7790

	REM round 4 pattern
	DATA $00ff,$ffff,$ffff,$ffff,$fff0
	DATA $0011,$f111,$11f1,$1111,$f110
	DATA $00f1,$f1f1,$f1f1,$f1f1,$f1f0
	DATA $00ff,$fff1,$ffff,$f1ff,$fff0
	DATA $0011,$1111,$1111,$1111,$1110

	REM round 5 cmart
	DATA $6602,$0002,$0ccc,$0999,$0aaa
	DATA $6002,$2022,$0c0c,$0909,$00a0
	DATA $6002,$0202,$0ccc,$0990,$00a0
	DATA $6602,$0002,$0c0c,$0909,$00a0
	DATA $0000,$0000,$0000,$0000,$0000	

	REM round 6 rev
	DATA $0009,$9909,$9909,$0909,$0000
	DATA $0009,$0909,$0009,$0909,$0000
	DATA $0009,$9009,$9909,$0909,$0000
	DATA $0009,$0909,$0009,$0900,$0000
	DATA $0009,$0909,$9900,$9009,$0000	

	REM round 7 inferno
	DATA $0000,$000a,$cccc,$a000,$0000
	DATA $0000,$00ac,$eeee,$ca00,$0000
	DATA $0000,$0ace,$FFFF,$eca0,$0000
	DATA $0000,$00ac,$eeee,$ca00,$0000
	DATA $0000,$000a,$cccc,$a000,$0000	

	REM round 8 wave
	DATA $0000,$1111,$1111,$0000,$0000
	DATA $0001,$dddd,$dddd,$1000,$0000
	DATA $001d,$ffff,$ffff,$d100,$0000
	DATA $01df,$7777,$7777,$fd10,$0000
	DATA $0000,$0000,$0000,$0000,$0000

	REM round 9 fish
	DATA $04e0,$00e4,$eeee,$e000,$00d0
	DATA $04ee,$0ee4,$ee0e,$ee00,$00d0
	DATA $00ee,$4ee4,$ee4e,$0000,$00d0
	DATA $04ee,$0ee4,$ee4e,$0000,$d0d0
	DATA $04e0,$00e4,$ee4e,$e000,$d220	
	
	REM round 10 rocket
	DATA $0000,$0005,$1100,$0000,$0000
	DATA $02a0,$0805,$1111,$0000,$0000
	DATA $0002,$0885,$1111,$1100,$0000
	DATA $02a0,$0805,$1111,$1150,$0202
	DATA $0000,$0005,$5555,$5550,$0000

	REM blank
	DATA $0000,$0000,$0000,$0000,$0000
	DATA $0000,$0000,$0000,$0000,$0000
	DATA $0000,$0000,$0000,$0000,$0000
	DATA $0000,$0000,$0000,$0000,$0000
	DATA $0000,$0000,$0000,$0000,$0000
	
	rem wip levels
	REM fish
	DATA $0ee0,$00ee,$eeee,$e000,$00d0
	DATA $0eee,$0eee,$ee0e,$ee00,$0010
	DATA $00ee,$eeee,$eeee,$e000,$0010
	DATA $0eee,$0eee,$eeee,$0000,$1010
	DATA $0ee0,$00ee,$eeee,$e000,$1110	
	
	REM  squares
	DATA $0ff0,$0dd0,$0bb0,$0bb0,$0000
	DATA $0ff0,$0dd0,$0bb0,$0bb0,$0000
	DATA $000e,$e00c,$c00a,$a00c,$c000
	DATA $000e,$e00c,$c00a,$a00c,$c000
	DATA $0000,$0000,$0000,$0000,$0000
	
	REM  faces
	DATA $0077,$7777,$0000,$7777,$7700
	DATA $0771,$7177,$7007,$7177,$1770
	DATA $0777,$7777,$7007,$7777,$7770
	DATA $0727,$7727,$7007,$7722,$7770
	DATA $0072,$2277,$0000,$7277,$2700
	
	
gramchars:

REM 0

	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."
	BITMAP "....#..."
	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "....#..."
	BITMAP ".....#.."
	
REM 1

	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."
	BITMAP "....#..."
	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "....##.."
	BITMAP "....#..."
	
REM 2

	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."
	BITMAP "....#..."
	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "....#.#."
	BITMAP "...#...."
	
REM 3

	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."
	BITMAP "....#..."
	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "...##..."
	BITMAP "......#."
	
REM 4
	BITMAP "........"
	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."

	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "....#..."
	BITMAP ".....#.."
	
REM 5
	BITMAP "........"	
	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."

	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "....##.."
	BITMAP "....#..."
	
REM 6
	BITMAP "........"
	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."

	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "....#.#."
	BITMAP "...#...."
	
REM 7
	BITMAP "........"
	BITMAP "...####."
	BITMAP "...###.."
	BITMAP "...####."

	
	BITMAP "..######"
	BITMAP "..#.#..."
	BITMAP "...##..."
	BITMAP "......#."

REM 8

	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "######.."
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"


REM 9
	
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "#......."
	BITMAP ".#####.."
	BITMAP "........"
	BITMAP "........"

REM 10

	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "#......."
	BITMAP ".#......"
	BITMAP "..####.."
	BITMAP "........"
	
REM 11

	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "########"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"

REM 12,13

	BITMAP "...##..."
	BITMAP "...##..."
	BITMAP "........"
	BITMAP "########"
	BITMAP "#.####.#"
	BITMAP "#.####.#"
	BITMAP ".######."
	BITMAP "..####.."

	BITMAP "..####.."
	BITMAP "..#..#.."
	BITMAP ".##..##."
	BITMAP ".#....#."
	BITMAP ".#....#."
	BITMAP ".#....#."
	BITMAP "##....##"
	BITMAP "........"

	REM 14, 15

	BITMAP "...##..."
	BITMAP "...##..."
	BITMAP "........"
	BITMAP ".######."
	BITMAP "#.####.#"
	BITMAP "#.####.#"
	BITMAP "#.####.#"
	BITMAP "#.####.#"

	BITMAP "..####.."
	BITMAP "..#..#.."
	BITMAP "..#..#.."
	BITMAP "..#..#.."
	BITMAP "..#..#.."
	BITMAP "..#..#.."
	BITMAP "..#..#.."
	BITMAP "........"

	REM 16,17
	BITMAP "#......#"
	BITMAP "#..##..#"
	BITMAP "#..##..#"
	BITMAP "#......#"
	BITMAP ".######."
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..####.."
	
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..#..#.."
	BITMAP ".##..##."
	BITMAP ".#....#."
	BITMAP ".#....#."
	BITMAP "##....##"
	BITMAP "........"


REM 18
	
	BITMAP "..####.."
	BITMAP ".#######"
	BITMAP ".#######"
	BITMAP ".#######"
	BITMAP ".#######"
	BITMAP "..#####."
	bitmap "...###.."	
	BITMAP "....#..."

REM 19
	
	BITMAP "..####.."
	BITMAP ".#######"
	BITMAP ".##..###"
	BITMAP ".##..###"
	BITMAP ".#######"
	BITMAP "..#####."
	bitmap "...###.."	
	BITMAP "....#..."
	
gramchars2:
REM 20
	
	BITMAP "..####.."
	BITMAP ".##..###"
	BITMAP ".##...##"
	BITMAP ".##...##"
	BITMAP ".##...##"
	BITMAP "..##.##."
	bitmap "...###.."	
	BITMAP "....#..."
	
REM 21
	
	BITMAP "..####.."
	BITMAP ".#.....#"
	BITMAP ".#.....#"
	BITMAP ".#..#..#"
	BITMAP ".#.....#"
	BITMAP "..#...#."
	bitmap "...#.#.."	
	BITMAP "....#..."
	
REM 22
	
	BITMAP "...#.#.."
	BITMAP ".#......"
	BITMAP "#...#..#"
	BITMAP ".#.###.."
	BITMAP "#...#..#"
	BITMAP "..#....."
	bitmap "......#."	
	BITMAP "....#..."
	
REM 23
	
	BITMAP "........"
	BITMAP "....#..."
	BITMAP "...###.."
	BITMAP "..#####."
	BITMAP "...###.."
	BITMAP "....#..."
	bitmap "........"	
	BITMAP "........"

REM 24
	
	BITMAP "....#..."
	BITMAP "....#..."
	BITMAP "...###.."
	BITMAP ".#######"
	BITMAP "...###.."
	BITMAP "....#..."
	bitmap "....#..."	
	BITMAP "........"

REM 25
	
	BITMAP "........"
	BITMAP "........"
	BITMAP "....#..."
	BITMAP "...###.."
	BITMAP "....#..."
	BITMAP "........"
	bitmap "........"	
	BITMAP "........"

	REM 26
	
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "....#..."
	BITMAP "........"
	BITMAP "........"
	bitmap "........"	
	BITMAP "........"
	
		REM 27
	
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "....#..."
	BITMAP "........"
	BITMAP "........"
	bitmap "........"	
	BITMAP "........"
	
		REM 28,29
	BITMAP "........"
	BITMAP "........"
	BITMAP "#......#"
	BITMAP "#..##..#"
	BITMAP "#..##..#"
	BITMAP "#......#"
	BITMAP ".######."
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..####.."
	
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..#..#.."
	BITMAP ".##..##."
	BITMAP ".#....#."
	BITMAP ".#....#."
	
		REM 30,31
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "#......#"
	BITMAP "#..##..#"
	BITMAP "#..##..#"
	BITMAP "#......#"
	BITMAP ".######."
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..####.."
	
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..#..#.."
	BITMAP ".##..##."
	
		REM 32,33
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "#......#"
	BITMAP "#..##..#"
	BITMAP "#..##..#"
	BITMAP "#......#"
	BITMAP ".######."
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..####.."
	
	BITMAP "..####.."
	BITMAP "..####.."
	
		REM 34,35
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "#......#"
	BITMAP "#..##..#"
	BITMAP "#..##..#"
	BITMAP "#......#"
	BITMAP ".######."
	BITMAP "..####.."
	BITMAP "..####.."
	BITMAP "..####.."
	
REM 36,37
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "#......#"
	BITMAP "#..##..#"
	BITMAP "#..##..#"
	BITMAP "#......#"
	BITMAP ".######."
	
REM number # 38
REM name: generic squash 4

    BITMAP   "........"
	BITMAP   "........"
	BITMAP   "........"
	BITMAP   "........"
    BITMAP   "..###..."
    BITMAP   ".#####.."
    BITMAP   "#######."
    BITMAP   "........"

REM number # 39
REM name: generic squash 5

    BITMAP   "........"
	BITMAP   "........"
	BITMAP   "...#...."
	BITMAP   ".#.#.#.."
    BITMAP   "##...##."
    BITMAP   "........"
    BITMAP   "#######."
    BITMAP   "........"

gramchars3:

REM number # 40
REM name: generic squash 6
	BITMAP   "........"
	BITMAP   "...#...."
	BITMAP   ".#.#.#.."
    BITMAP   "##...##."
    BITMAP   "........"
    BITMAP   ".#####.."
	BITMAP   "#.....#."
    BITMAP   "........"

REM number # 41
REM name: generic squash 7

	BITMAP   "...#...."
	BITMAP   ".#.#..#."
    BITMAP   "##....##"
    BITMAP   ".#.#.#.."
    BITMAP   "..#.#..."
	BITMAP   "#.....#."
    BITMAP   "........"
	BITMAP   "........"

REM number # 42
REM name: generic squash 8

	BITMAP   "#..#..#."
	BITMAP   "#......#"
    BITMAP   "...#...."
    BITMAP   ".#....#."
    BITMAP   "....#..."
	BITMAP   "#.#....#"
    BITMAP   "........"
	BITMAP   "........"

REM number # 43
REM name: generic squash 8

	BITMAP   "........"
	BITMAP   "#..#..#."
	BITMAP   "#......#"
	BITMAP   "........"
	BITMAP   "..#....."
	BITMAP   "......#."
	BITMAP   "#.#....."
	BITMAP   "........"	

REM number # 44
REM name: generic squash 9
    BITMAP   "........"	
	BITMAP   "........"
	BITMAP   "#..#..#."
	BITMAP   "#......#"
	BITMAP   "........"
	BITMAP   "..#....."
	BITMAP   "......#."
	BITMAP   "#.#....."

REM number # 45
REM name: generic squash 10
    BITMAP   "........"	
    BITMAP   "........"	
	BITMAP   "........"
	BITMAP   "#..#..#."
	BITMAP   "#......#"
	BITMAP   "........"
	BITMAP   ".##....."
	BITMAP   "......#."

REM number # 46
REM name: generic squash 11
    BITMAP   "........"	
    BITMAP   "........"	
	BITMAP   "........"	
	BITMAP   "........"
	BITMAP   "#..#..#."
	BITMAP   "#......#"
	BITMAP   ".......#"
	BITMAP   ".##....."

REM number # 47
REM name: generic squash 11
    BITMAP   "........"	
    BITMAP   "........"	
	BITMAP   "........"	
	BITMAP   "........"
	BITMAP   "........"	
	BITMAP   "........"
	BITMAP   "#..#..#."
	BITMAP   "#.#.#..#"
	
REM number # 48
REM name: star
	BITMAP   "........"
    BITMAP   "....#..."	
    BITMAP   "...###.."	
	BITMAP   ".#######"	
	BITMAP   "..#####."
	BITMAP   ".##...##"	
	BITMAP   ".#.....#"
	BITMAP   "........"


REM number # 49
REM name: bottom line	
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "........"
	BITMAP "########"
	BITMAP "########"
	BITMAP "........"


	
	
	