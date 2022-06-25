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
	if crash then ' render player explosion
		sprite 0, mob_left+player_x, mob_top+player_y, sprite_explosion+(rand%8)
	else ' render player
		sprite 0, mob_left+player_x, mob_top+player_y, sprite_player
	end if
	
	if shot_y=0 then  ' no shot
		sprite 1, 0
	elseif shot_exp<> then ' render shot explosion
		sprite 1, mob_left+shot_x, mob_top+shot_y, sprite_explosion
	else ' render shot
		sprite 1, mob_left+shot_x, mob_top+shot_y, sprite_shot1
	end if
		
	'
	' synchronize game
	'
	wait
	
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
	' Shot management
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
	' Player management
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
	