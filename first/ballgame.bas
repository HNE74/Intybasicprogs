' 
 ' Game of Ball 
 ' by Oscar Toledo G. 
 ' Creation date: Jun/11/2018. 
 ' 
 CLS 
 MODE 0,0,0,0,0 
 WAIT 
 DEFINE 0,7,game_bitmaps_0 
 WAIT 
 
 '
 ' Draw the playfield
 '
 cls
 
 print at 0 color 1
 for c=1 to 20
   print "\256"
 next c
 
 print at 220
 for c=1 to 20
   print "\257"
 next c
 
 print at 9, "\258"
 
 for c=1 to 10
   print at c*20+9, "\259"
 next c
 
 print at 229, "\260"
 
 gosub update_score
 
 ' init game
 x1=23
 y1=42
 x2=137
 y2=42
 
 gosub restart_ball
 x=ox
 y=oy
 #dx=-2
 #dy=-2
 ball_speed=$20
 ball_current=0
 
 '
 ' Main game loop
 '
ball_loop:
 WAIT
 if sound_counter > 0 then 
	sound_counter=sound_counter-1
	if sound_counter=0 then sound 2,1,0
 end if
 
 ' draw paddles
 sprite 0, $0708+x1, $0208+y1, $0800+5*8+1
 sprite 1, $0708+x2, $0208+y2, $0800+5*8+2
 
 ' draw ball
 if ball=0 then
	sprite 2,0
 else
    sprite 2, $0708+x, $0208+y, $0800+6*8+6
 end if
 
 ' adjust paddle position
 if cont1.up then if y1>6 then y1=y1-2
 if cont1.down then if y1<74 then y1=y1+2

 if cont2.left then if y2>6 then y2=y2-2
 if cont2.right then if y2<74 then y2=y2+2
 
 if ball then ' match
	ball_current=ball_current+ball_speed
	if ball_current>=$40 then 
		' tentative adjust ball position
		ball_current=ball_current-$40
		ox=x
		oy=y
		x=x+#dx
		y=y+#dy
		
		' ball bumps on top or bottom of field
		if oy+#dy<2 then
			#dy=-#dy
			oy=2-#dy
			gosub ball
		end if
		if oy+#dy>90 then
			#dy=-#dy
			oy=90-#dy
			gosub ball
		end if
		
		' ball goes out of field
		if ox+#dx<2 then
			gosub ball_out
			gosub restart_ball
		end if
		if ox+#dx>158 then
			gosub ball_out
			gosub restart_ball
		end if
		
		' ball hits paddle line
		if x>x1-4 and x<x1+4 then
		  c=y1
		  gosub rebound
		end if
		if x>x2-4 and x<x2+4 then
		  c=y2
		  gosub rebound
		end if

		' adjust ball position
		x=ox+#dx
		y=oy+#dy
	end if
 else ' check continue match
	c = cont and $e0
	if (c=$a0)+(c=$c0)+(c=$60) then ball=1
 end if
 
goto ball_loop 
 
 '
 ' Ball touched wall
 '
ball: PROCEDURE
 sound 2,500,48
 sound 3,400,9
 sound_counter=10
END
 
 '
 ' Ball left the field
 '
ball_out: PROCEDURE
 if x<80 then
	score2=score2+1
 else
    score1=score1+1
 end if
 gosub update_score
 
 sound 2,330,48
 sound 3,70,10
 sound_counter=15
END

 
 '
 ' Update scores
 '
update_score: PROCEDURE
 ' show score at 2 digits aligned to right
 print at 27 color 1,<.2>score1
 ' show score as digits aligned to right
 print at 31 color 2,<>score2
 END
 
 '
 ' Restart the ball
 '
restart_ball: PROCEDURE
 d=RAND%8
 ox=80
 oy=48
 ball=0
 gosub get_angle
END

 '
 ' Rebound on paddle hit
 '
rebound: PROCEDURE
 if y<c-3 then return
 if y>c+15 then return
 if y<c then
  d=0
 else
  d=(y-c)/2
 end if
 gosub get_angle
 if ball_speed <$40 then ball_speed=ball_speed+1  
 
 sound 2,150,48
 sound 3,300,9
 sound_counter=5
END

 ' 
 ' Get angle per paddle position 
 ' Variable d contains the hit position. 
 ' Returns dx and dy with new direction. 
 ' 
get_angle: PROCEDURE 
 IF d = 0 THEN #dy = -2:IF #dx < 0 THEN #dx = 1 ELSE #dx = -1 
 IF d = 1 THEN #dy = -2:IF #dx < 0 THEN #dx = 2 ELSE #dx = -2 
 IF d = 2 THEN #dy = -1:IF #dx < 0 THEN #dx = 2 ELSE #dx = -2 
 IF d = 3 THEN #dy = 0:IF #dx < 0 THEN #dx = 2 ELSE #dx = -2 
 IF d = 4 THEN #dy = 0:IF #dx < 0 THEN #dx = 2 ELSE #dx = -2 
 IF d = 5 THEN #dy = 1:IF #dx < 0 THEN #dx = 2 ELSE #dx = -2 
 IF d = 6 THEN #dy = 2:IF #dx < 0 THEN #dx = 2 ELSE #dx = -2 
 IF d = 7 THEN #dy = 2:IF #dx < 0 THEN #dx = 1 ELSE #dx = -1 
END 
 
 '
 ' Graphics for borders of playfield, paddles and ball. 
 ' 
game_bitmaps_0: 
 BITMAP "11111111" 
 BITMAP "11111111" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "11111111" 
 BITMAP "11111111" 
 
 BITMAP "11111111" 
 BITMAP "11111111" 
 BITMAP "00000000" 
 BITMAP "00000001" 
 BITMAP "00000001" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000001"
 
 BITMAP "00000001" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000001" 
 BITMAP "00000001" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000001" 

 BITMAP "00000001" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000001" 
 BITMAP "00000001" 
 BITMAP "00000000" 
 BITMAP "11111111" 
 BITMAP "11111111" 
 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 BITMAP "11000000" 
 
 BITMAP "11000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000" 
 BITMAP "00000000"
 
 
