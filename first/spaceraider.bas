' 
 ' Space Raider 
 ' by Oscar Toledo G. 
 ' modified by Noltisoft
 ' Creation date: Jun/11/2018. 
 ' 
UNSIGNED #score 
CONST STAR = $000E * 8 + 2 
CONST SPRITE_PLAYER = $0807 + 0 * 8 
CONST SPRITE_SHOT1 = $0805 + 1 * 8 
CONST SPRITE_SHOT2 = $1805 + 2 * 8 
CONST SPRITE_EXPLOSION = $1800 + 3 * 8 
CONST SPRITE_SHIP_1 = $0805 + 4 * 8 
CONST SPRITE_SHIP_2 = $0805 + 5 * 8 
CONST SPRITE_SHIP_3 = $0805 + 6 * 8 
CONST SPRITE_SHIP_4 = $0805 + 7 * 8 
CONST SPRITE_SHIP_5 = $0805 + 8 * 8 
CONST SPRITE_SHIP_6 = $0805 + 9 * 8 
CONST SPRITE_SHIP_7 = $0805 + 10 * 8 
CONST SPRITE_SHIP_8 = $0805 + 11 * 8 
CONST MOB_LEFT = $0300 
CONST MOB_TOP = $0100 
DIM stars(20) 
 
DIM ex(6) 
DIM ey(6) 
DIM ef(6) 
DIM es(6) 
CLS 
MODE 0,0,0,0,0 
WAIT 
DEFINE 0,12,game_bitmaps 
WAIT 

start_game: 
	cls
	
	'
	' Init star background
	'
	for c=0 to 19
		stars(c) = (random(11)+1) * 20 + c
		#backtab(stars(c))=STAR
	next c

	#score=0
	lives=2
	
	'
	' Init enemies
	'
	for c=0 to 5
		ex(c)=0
	next c
	next_wave=100+random(40)

'
' Restart game after loosing live
'
restart_game:
	player_x=84
	player_y=88
	shot_y=0

'
' Main game loop
'	
game_loop:
	'
	' manage player visibility
	'
	if crash then ' render player explosion
		sprite 0, mob_left+player_x, mob_top+player_y, sprite_explosion+(rand%8)
	else ' render player
		sprite 0, mob_left+player_x, mob_top+player_y, sprite_player
	end if
	
	'
	' manage enemy shots
	'
	for c=3 to 5
		if ex(c) then ' move shots down
			ey(c)=ey(c)+2
			if ey(c)>=104 then ex(c)=0
		elseif ex(c-3) ' spawn shots
			if random(2) then
				ex(c)=ex(c-3)
				ey(c)=ey(c-3)
			end if
		end if
	next c
	
	'
	' manage player shot visibility
	'
	if shot_y=0 then ' no shot
		sprite 1, 0
	elseif shot_exp<> then ' render shot explosion
		sprite 1, mob_left+shot_x, mob_top+shot_y, sprite_explosion
	else ' render shot
		sprite 1, mob_left+shot_x, mob_top+shot_y, sprite_shot1
	end if
		
	' 
	' manage enemie visibility
	'
	something=0
	for c=0 to 2
		if ex(c) then ' render enemy
			sprite 2+c, mob_left+ex(c), mob_top+(ey(c) and $7f), sprite_frame(ef(c))
			something=1
		else ' no enemy
			sprite 2+c, 0
		end if
	next c
	
	' 
	' manage enemie shot visibility
	'	
	for c=3 to 5
		if ex(c) then
			sprite 2+c, mob_left+ex(c), mob_top+(ey(c) and $7f), sprite_frame(9)
			something=1
		else
			sprite 2+c, 0
		end if
	next c	
		
	'
	' synchronize game
	'
	wait
	
	'
	' check collision player with enemy
	'
	if col0 and $00fc then
		if crash=0 then crash=60
	end if
	
	'
	' check collision of enemy with player bullet
	'
	if col1 and $00fc then
		c=255
		if col2 and $0002 then c=0
		if col3 and $0002 then c=1
		if col4 and $0002 then c=2
		if col5 and $0002 then c=3
		if col6 and $0002 then c=4
		if col7 and $0002 then c=5
		if c<3 then ' enemy destroyed
			if ex(c) then
				shot_x=ex(c):shot_y=ey(c)
				shot_exp=4
				ex(c)=0
				#score=#score+1
			end if
		elseif c<6 then ' bullet destroyed
			ex(c)=0
		end if
	end if
		 		
	'
	' move stars backdrop, 10 stars are updated per loop iteration
	' dependent on frame is even or odd
	'
	c=frame and 1
	start=c*10
	last=start+9
	for c=start to last
		d=stars(c)
		#backtab(d)=0
		if d>=220 then 
			if random(2) then
				d=d-180
			else
				d=d-200
			end if
		else
			d=d+20
		end if
		#backtab(d)=star
		stars(c)=d
	next c
	
	'
	' print score and number of lives
	'
	print at 0 color 3,<5>#score,"0"
	#backtab(19)=(lives+$10)*8+3
	
	'
	' player destroyed countdown
	'
	if crash then
		crash=crash-1
		if crash=0 then goto game_over
	end if
	
	'
	' enemy wave management
	'
	if next_wave then
		if something=0 then ' countdown to next wave
			next_wave=next_wave-1
		else
			on wave gosub move_wave_0, move_wave_1
		end if
	else ' init countdown to next wave 
		next_wave=20+random(20)
		wave=random(2)
		on wave gosub start_wave_0_1, start_wave_0_1
	end if
		
	'
	' player shot management
	'	
	if shot_y<>0 then ' check shot
		if shot_exp then ' shot has exploded
			shot_exp=shot_exp-1
			if shot_exp=0 then shot_y=0 ' no shot
		else
			if shot_y>2 then
				shot_y=shot_y-3
			else
				shot_y=0
			end if
		end if
	end if
	
	'
	' player management
	'
	c = cont
	d = c and $e0
	if (d=$80)+(d=$40)+(d=$20) then
		' keypad pressed
	else
		if (d=$60)+(d=$a0)+(d=$c0) then ' side button pressed
			if shot_y=0 then ' spawn shot
				shot_x=player_x
				shot_y=player_y
				shot_exp=0
			end if
		end if
		
		' player horizontal movement
		d=controller_direction(c and $1F)
		if d=2 then
			if player_x<160 then player_x=player_x+2
		elseif d=4 then
			if player_x>8 then player_x=player_x-2
		end if
		
	end if
				
	goto game_loop
	
'
' player hit and game over
'
game_over:
	' reset all mobs
	for c=0 to 7
		sprite c,0
	next c
	
	if lives<>0 then ' restart game
		lives=lives-1
		goto restart_game
	end if
	
	' no lives left -> game over
	print at 85 color 6, "GAME  OVER"
	for c=0 to 60
		wait
	next c
	
	' wait for new game
	do 
		c=cont
	loop while c
	do 
		c=cont
	loop while c=0	
	
	goto start_game
	
'
' start waves 0 and 1
'
start_wave_0_1:	procedure
	'???
	c=player_x 
	if<24 then c=24
	if c>144 then c=144
	
	' Init enemies
	x=random(32)+player_x-16	
	ex(0)=x-16:ey(0)=-16:ef(0)=4
	ex(1)=x:ey(1)=-8:ef(1)=4
	ex(2)=x+16:ey(2)=-16:ef(2)=4
end

'
' wave 0 enemy ship movement
'
move_wave_0: procedure
	wave_state=wave_state+1
	
	' wave end
	if wave_state=120 then
		ex(0)=0:ex(1)=0:ex(2)=0
		return
	end if
	
	' horizontal movement 
	if wave_state>=32 and wave_state<=39 then
		if ex(0) then
			ef(0)=5:ex(0)=ex(0)-1
		end if
		if ex(1) then
			ef(1)=5:ex(1)=ex(1)-1
		end if	
		if ex(2) then
			ef(2)=5:ex(2)=ex(2)-1
		end if	
	elseif wave_state=40 then
		ef(0)=4:ef(1)=4:ef(2)=4
	elseif wave_state>=64 and wave_state<=71 then
		if ex(0) then
			ef(0)=3:ex(0)=ex(0)+1
		end if
		if ex(1) then
			ef(1)=3:ex(1)=ex(1)+1
		end if	
		if ex(2) then
			ef(2)=3:ex(2)=ex(2)+1
		end if	
	elseif wave_state=72 then
		ef(0)=4:ef(1)=4:ef(2)=4
	end if
	
	' vertical movement
	if ex(0) then 
		ey(0)=ey(0)+1
	end if
	if ex(1) then 
		ey(1)=ey(1)+1
	end if
	if ex(2) then 
		ey(2)=ey(2)+1
	end if	
end

'
' wave 1 enemy ship movement
'
move_wave_1: procedure
	wave_state=wave_state+1
	
	' wave end
	if wave_state=120 then
		ex(0)=0:ex(1)=0:ex(2)=0
		return
	end if
	
	if wave_state>=32 and wave_state<=39 then	
		if ex(0) then
			ef(0)=5:ex(0)=ex(0)-1
		end if
		if ef(2) then
			ef(2)=3
			ex(2)=ex(2)+1
		end if
	elseif wave_state=40 then
		ef(0)=4
		ef(2)=4
	elseif wave_state>=64 and wave_state<=71 then
		if ex(0) then
			ef(0)=3
			ex(0)=ex(0)+1
		end if
		if ex(2) then
			ef(2)=5
			ex(2)=ex(2)-1		
		end if
	 elseif wave_state=72 then
		ef(0)=4
		ef(2)=4	 
	 end if
		
	' vertical movement
	if ex(0) then 
		ey(0)=ey(0)+1
	end if
	if ex(1) then 
		ey(1)=ey(1)+1
	end if
	if ex(2) then 
		ey(2)=ey(2)+1
	end if	
end
		
'
' enemy sprite frame definition
'
sprite_frame:
	data sprite_ship_1
	data sprite_ship_2
	data sprite_ship_3
	data sprite_ship_4
	data sprite_ship_5
	data sprite_ship_6
	data sprite_ship_7
	data sprite_ship_8
	data sprite_explosion
	data sprite_shot2
	
'
' controller direction translation data
'
controller_direction:
	data 0,3,2,3,1,0,2,0
	data 4,4,0,0,1,0,0,0
	data 0,3,2,0,0,0,0,0
	data 4,0,0,0,1,0,0,0
	
' 
' Bitmaps used for game 
' 
game_bitmaps: 
	BITMAP "...XX..."
	BITMAP "..XXXX.." 
	BITMAP "..X..X.." 
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXXXXXX" 
	BITMAP ".XX..XX." 
	BITMAP ".X....X."
	
	BITMAP "........" 
	BITMAP "........" 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "........" 
	BITMAP "...X...." 
	
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "........" 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "........" 
	
	BITMAP "...X..X." 
	BITMAP ".X.X.XX." 
	BITMAP "XX.X...." 
	BITMAP ".....X.X" 
	BITMAP ".......X" 
	BITMAP ".X.X...." 
	BITMAP "X....X.." 
	BITMAP "...X..X."
	
	BITMAP "..X..X.." 
	BITMAP ".XX..XX." 
	BITMAP "XXX..XXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXX..XXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXX..." 
	BITMAP "XXXX...X" 
	BITMAP "XXXXX.XX" 
	BITMAP "XX.XXXXX" 
	BITMAP "XXX.XXXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXXXXXX" 
	BITMAP "XX.XX..." 
	BITMAP "XX.XX..." 
	BITMAP "XXXXXXXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.."
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXX.XXXX" 
	BITMAP "XX.XXXXX" 
	BITMAP "XXXXX.XX" 
	BITMAP "XXXX...X" 
	BITMAP ".XXXX..." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXX..XXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXX..XXX" 
	BITMAP ".XX..XX." 
	BITMAP "..X..X.."
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXX.XXX" 
	BITMAP "XXXXX.XX" 
	BITMAP "XX.XXXXX" 
	BITMAP "X...XXXX" 
	BITMAP "...XXXX." 
	BITMAP "..XXXX.."
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXXXXXX" 
	BITMAP "...XX.XX" 
	BITMAP "...XX.XX" 
	BITMAP "XXXXXXXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP "...XXXX." 
	BITMAP "X...XXXX" 
	BITMAP "XX.XXXXX" 
	BITMAP "XXXXX.XX" 
	BITMAP "XXXX.XXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.."	
	