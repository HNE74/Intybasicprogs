	'
	' Monkey moon
	' by Oscar Toledo G.
	' Creation date: Jun/11/2018.
	'
	
	unsigned #score,#bonus
	signed offset_y
	
	dim rock_x(6) ' x position rocks
	dim rock_y(6) ' y position rocks
	dim rock_s(6) ' state of rocks
	
	
	' Game constants
	CONST MOB_LEFT = $0308 ' Enabled + interact + hidden border
	CONST MOB_TOP = $0108 ' Normal size + hidden border
	CONST MIRROR_X = $0400 ' Sprite reflected in X direction
	CONST MIRROR_Y = $0800 ' Sprite reflected in Y direction
	
	' Level constants, card color is determined by last digit of addres $080X
	CONST OO = 0
	CONST GA = $0801 + 0 * 8
	CONST GB = $0801 + 1 * 8
	CONST GC = $0801 + 2 * 8
	CONST GD = $0801 + 3 * 8
	CONST GE = $0801 + 4 * 8
	CONST LA = $0805 + 5 * 8
	CONST RA = $0802 + 6 * 8
	CONST RB = $0802 + 7 * 8
	CONST MF = $0806 + 8 * 8 ' Monkey face
	CONST MA = $0802 + 9 * 8
	CONST MB = $0802 + 10 * 8
	CONST MC = $0802 + 11 * 8
	CONST MD = $0802 + 12 * 8
	CONST PA = $0807 + 14 * 8
	CONST PB = $0807 + 13 * 8
	CONST PC = $0807 + 15 * 8
	CONST PD = $0807 + 16 * 8	
	
	' Init graphics
	cls
	mode 0,0,0,0,0
	wait
	define 0,16,game_bitmaps_0
	wait
	define 16,1,game_bitmaps_1
	wait
	
	' Init sound effect handler to be called each frame
	on frame gosub play_effects
	
	' Game
start_game:

	cls
	print at 46 color 7, "Monkey"
	print at 70, "Moon"
	print at 129, MA,MC
	print at 149, MB,MD
	sprite 7, mob_left+9*8+4, mob_top+6*8, MF
	print at 202 color 6, "Press any button"
	
	do 
		c=cont
	loop while c
		do 
		c=cont
	loop while c=0	

	#score=0
	level=0
	lives=2
	
next_level:
	level=level+1
	if level>5 then #bonus=50 else #bonus=110-level*10

restart_level:
	cls
	screen level1_cards
	
	for c=0 to 6
		sprite c, 0
	next c
	sprite 7,mob_left+13*8+4, mob_top+1*8,mf ' monkey face color
	
	' init player
	player_x=16 
	player_y=80
	player_state=0
	player_jumping=0
	
	' init rocks
	for c=0 to 5
		rock_y(c)=0
	next c
	rock_time=rand(30)+10
	
	'
	' Loop for the game
	'
game_loop:

	' show rocks
	for c=0 to 5
		if rock_y(c) then ' check rock active
			x=rock_x(c)
			y=rock_y(c)
			if rock_s(c)<2 then
				gosub get_offset
				' check player jumps rock
				if x=player_x and y=player_y then #score=#score+10 
			else
				offset_y=0
			end if
			sprite c+1,mob_left+rock_x(c), mob_top+rock_y(c)+offset_y+rock_mirror((frame/4) and 3), rock_animation((frame/4) and 1)
		else ' disable rock
			sprite c+1,0
		end if		
	next c

	x=player_x
	y=player_y
	
	' adjust player y position by offset
	if player_jumping then
		offset_y = jump_y(player_jumping-1)+player_offset
	elseif player_state<>2 and player_state<>6 then
		gosub get_offset
		player_offset=offset_y
	else
		offset_y=0
		player_offset=0
	end if
	
	' set player look by it's state
	if player_state=0 then
		sprite 0, mob_left+player_x, mob_top+player_y+offset_y, PA
	elseif player_state=1 then 
		sprite 0, mob_left+player_x, mob_top+player_y+offset_y, PB
	elseif player_state=2 then 
		sprite 0, mob_left+player_x, mob_top+player_y+offset_y, PC		
	elseif player_state=4 then 
		sprite 0, mob_left+player_x, mob_top+mirror_x+player_y+offset_y, PA
	elseif player_state=5 then 
		sprite 0, mob_left+player_x, mob_top+mirror_x+player_y+offset_y, PB
	elseif player_state=6 then 
		sprite 0, mob_left+player_x, mob_top+mirror_x+player_y+offset_y, PC	
	end if
	WAIT
	
	' decrease bonus
	if frame%256=0 then
		if #bonus>0 then #bonus=#bonus-10
	end if
	
	' print game state
	print at 0 color 7, <5>#score,"0"
	print at 12, <.2>level
	print at 16 color 7, <.3>#bonus,"0"
		
	' check player collision with stone
	if col0 and $007e then goto player_defeat
		
	' check if player has won
	if player_y=0 then goto level_won
	
	' player jumps
	if player_jumping then
		if player_jumping=24 then
			player_jumping=0
		else
			player_jumping=player_jumping+1
		end if
	end if
	
	' add rock
	rock_time=rock_time-1
	if rock_time=0 then
		if level>10 then c=60 else c=100+5*(10-level)
		rock_time=c+random(45) ' determine when next rock appears
		for c=0 to 5 ' new rock appears
			if rock_y(c)=0 then
				rock_x(c)=96
				rock_y(c)=16
				rock_s(c)=0
				exit for
			end if
		next c
	end if
	
	' move rocks
	for c=0 to 5
		if rock_y(c) then
			if rock_s(c) = 0 then ' rock goes left
				platform=rock_y(c)/16
				if rock_x(c)>min_platform(platform) then
					rock_x(c)=rock_x(c)-1 
				else
					rock_y(c)=rock_y(c)+4 ' rock goes down
					rock_x(c)=rock_x(c)-4
					rock_s(c)=3
					print at 0,"e"
				end if									
			elseif rock_s(c) = 1 then ' rock goes right
				platform=rock_y(c)/16
				if rock_x(c) < max_platform(platform) then
					rock_x(c)=rock_x(c)+1 
				else
					rock_y(c)=rock_y(c)+4 ' rock goes down
					rock_x(c)=rock_x(c)+4
					rock_s(c)=2
				end if
			elseif rock_s(c)>=2 then ' falling rock
				rock_y(c)=rock_y(c)+1
				if rock_y(c)>=96 then 
					rock_y(c)=0 ' rock left screen
				elseif rock_y(c)%16=0 then' rock has hit platform
					rock_s(c)=rock_s(c)%2 ' rock goes left or right again
				end if
			end if			
		end if
	next c

		
	c=cont
    d=c and $e0
	if (d=$80) + (d=$40) + (d=$20) then
		' keypad pressed
	elseif (d=$60) + (d=$a0) + (d=$c0) then
		' side button pressed
		if player_jumping=0 then
			player_jumping=1
			sound_effect=2:sound_state=0
		end if
	else
		d=controller_direction(c and $1F)
	
		'print at 20 color 7, <>frame		
		if d=1 then ' going up
			if player_y%16=0 then ' over flor
				x=(player_x + 4)/8
				y=player_y/8
				if #backtab(y*20+x)=LA then ' start climb
					player_y=player_y-1
					player_state=2
				end if
			elseif (frame and 1) = 0 then ' over ladder
				player_y=player_y-1	' go up
				if (frame and 3) = 0 then ' animate player
					player_state=player_state xor 4			
				end if
				if player_y%16=4 then	'top end of ladder reached
					player_y=player_y-4
					player_state=0
				end if
			end if
		end if
		
		if d=3 then ' going down
			if player_y%16=0 then ' over flor
				x=(player_x + 4)/8
				y=player_y/8+2
				if #backtab(y*20+x)=LA then ' start descend
					player_y=player_y+5
					player_state=2
				end if
			elseif (frame and 1) = 0 then ' over ladder
				player_y=player_y+1 ' go down
				if (frame and 3) = 0 then ' animate player
					player_state=player_state xor 4
				end if
			end if
		end if		
		
		if d=2 then ' going right
			if player_y%16 = 0 then ' player aligned with girder
				platform = player_y/8/2 ' calculate platform index
				if player_x<max_platform(platform) then
					sound_effect=1:sound_state=0
					player_x=player_x+1
					if player_state<>0 and player_state<>1 then
						player_state=0
					elseif (frame and 3)=0 then
						player_state=player_state xor 1
					end if
				end if
			end if
		end if
		
		if d=4 then ' going left
			if player_y%16 = 0 then ' player aligned with girder
				platform = player_y/8/2 ' calculate platform index
				if player_x>min_platform(platform) then
					sound_effect=1:sound_state=0
					player_x=player_x-1
					if player_state<>4 and player_state<>5 then
						player_state=4
					elseif (frame and 3)=0 then
						player_state=player_state xor 1
					end if
				end if
			end if
		end if
	end if
	
	goto game_loop
	
	'
	' Player has won the level
	'
level_won:
	#score=#score+#bonus
	print at 0 color 7,<5>#score,"0"
	for c=1 to 6
		sprite c,0
	next c
	
	sound_effect=4:sound_state=0
	for c=0 to 60
		wait
	next c
	goto next_level
	
	'
	' Player has been defeated
	'
player_defeat:
	sound_effect=3:sound_state=0
	for c=0 to 60 ' animate player defeated
		wait
		d=(frame/4) and 3
		if d=0 then
			sprite 0, mob_left+player_x, mob_top+player_y+offset_y, PA
		elseif d=1 then
			sprite 0, mob_left+player_x, mob_top+player_y+offset_y, PD
		elseif d=2 then
			sprite 0, mob_left+player_x, mob_top+mirror_x+mirror_y+player_y+offset_y, PA
		else
			sprite 0, mob_left+player_x, mob_top+mirror_x+mirror_y+player_y+offset_y, PD
		end if
	next c
	
	' respawn player
	if lives<>0 then
		lives=lives-1
		goto restart_level
	end if
	
	' game over
	for c=0 to 6
		sprite c,0
	next c
	print at 125 color 6, "GAME OVER"
	for c=0 to 60
		wait
	next c
	
	' wait for restart of game
	do 
		c=cont
	loop while c
		do 
		c=cont
	loop while c=0
	goto start_game
	
 '
 ' Sound effects
 '
play_effects: PROCEDURE
	on sound_effect gosub sound_none, sound_walk, sound_jump, sound_death, sound_victory
END

sound_none: PROCEDURE
	sound 0,,0
END

sound_walk: PROCEDURE
	if (frame and 15) < 2 then sound 0,200,10 else sound 0,,0
	sound_state=sound_state+1
	if sound_state=3 then sound_effect=0
END

sound_jump: PROCEDURE
	sound 0,200-sound_state*10,10
	sound_state=sound_state+1
	if sound_state=10 then sound_effect=0
END

sound_death: PROCEDURE
	sound 0,1000+(sound_state/4%2)*500,10
	sound_state=sound_state+1
	if sound_state=30 then sound_effect=0
END

sound_victory: PROCEDURE
	sound 0,150-sound_state*5,10
	sound_state=sound_state+1
	if sound_state=10 then sound_effect=0
END	
		
	'
	' Min and max platform MOB coordinates
	'
min_platform: 
	DATA 0 
	DATA 28 
	DATA 20 
	DATA 28 
	DATA 20 
	DATA 12 
max_platform: 
	DATA 0 
	DATA 96 
	DATA 123 
	DATA 131 
	DATA 131 
	DATA 139 	
	
	'
	' Rock animtion data
	'
rock_animation:
	data RA
	data RB

rock_mirror:
	data $0000
	data $0000
	data MIRROR_X
	data MIRROR_Y
	
	'
	' Player jump y offsets
	'
jump_y: 
	DATA -2 
	DATA -4 
	DATA -5 
	DATA -6 
	DATA -7 
	DATA -8 
	DATA -9 
	DATA -9 
	DATA -10 
	DATA -10 
	DATA -11 
	DATA -11 
	DATA -11 
	DATA -11 
	DATA -10 
	DATA -10 
	DATA -9 
	DATA -9 
	DATA -8 
	DATA -7 
	DATA -6 
	DATA -5 
	DATA -4 
	DATA -2 

	'
	' Bitmaps for the game (first section)
	'
game_bitmaps_0:
	BITMAP "XXXXXXXX" ' 0
	BITMAP "..X...X."
	BITMAP ".X.X.X.X"
	BITMAP "XXXXXXXX"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "........" ' 1 
	BITMAP "XXXXXXXX"
	BITMAP "..X...X."
	BITMAP ".X.X.X.X"
	BITMAP "XXXXXXXX"
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "........" ' 2
	BITMAP "........"
	BITMAP "XXXXXXXX"
	BITMAP "..X...X."
	BITMAP ".X.X.X.X"
	BITMAP "XXXXXXXX"
	BITMAP "........"
	BITMAP "........"
	
	BITMAP "........" ' 3
	BITMAP "........"
	BITMAP "........"
	BITMAP "XXXXXXXX"
	BITMAP "..X...X."
	BITMAP ".X.X.X.X"
	BITMAP "XXXXXXXX"
	BITMAP "........"
	
	BITMAP "........" ' 4
	BITMAP "........"
	BITMAP "........"
	BITMAP "........"
	BITMAP "XXXXXXXX"
	BITMAP "..X...X."
	BITMAP ".X.X.X.X"
	BITMAP "XXXXXXXX"
	
	BITMAP ".X....X." ' 5 	
	BITMAP ".X....X."
	BITMAP ".XXXXXX."
	BITMAP ".X....X."
	BITMAP ".X....X."
	BITMAP ".XXXXXX."
	BITMAP ".X....X."
	BITMAP ".X....X."
	 
	BITMAP ".XXXXX.." ' 6
	BITMAP "XXXXXXX."
	BITMAP "XXXXXXX."
	BITMAP "XXXXXXX."
	BITMAP ".XXXXX.X"
	BITMAP ".XXXX.XX"
	BITMAP "..XXXXX."
	BITMAP "........"
	
	BITMAP "....XXX." ' 7
	BITMAP "..XXXXXX"
	BITMAP ".XX.XXXX"
	BITMAP ".X.XXXXX"
	BITMAP ".XXXXXXX"
	BITMAP ".XXXXXXX"
	BITMAP ".XXXXXX."
	BITMAP "..XX...."
	 
	BITMAP "........" ' 8
	BITMAP "..XXXX.."
	BITMAP ".X.XX.X."
	BITMAP ".XXXXXX."
	BITMAP ".X.XX.X."
	BITMAP ".XX..XX."
	BITMAP "XXXXXXXX"
	BITMAP ".XXXXXX."
	
	BITMAP ".....XXX" ' 9
	BITMAP "....XX.."
	BITMAP "....X.X."
	BITMAP "....X..."
	BITMAP "..XXX.X."
	BITMAP "..XXX..X"
	BITMAP "...X...."
	BITMAP "....X..."
	
	BITMAP "....XXXX" ' 10
	BITMAP "..XXXXXX"
	BITMAP ".XX.XXXX"
	BITMAP "XX..XXXX"
	BITMAP "XX..XXXX" 
	BITMAP "XX...XXX"
	BITMAP "XXX.XXX."
	BITMAP "XX.XXX.."
	
	BITMAP "XXX....." ' 11
	BITMAP "..XX...."
	BITMAP ".X.X...."
	BITMAP "...X...."
	BITMAP ".X.XXX.."
	BITMAP "X..XXX.."
	BITMAP "....X..."
	BITMAP "...X...."
	
	BITMAP "XXXX...." ' 12
	BITMAP "XXXXXX.."
	BITMAP "XXXX.XX."
	BITMAP "XXXX..XX"
	BITMAP "XXXX..XX"
	BITMAP "XXX...XX"
	BITMAP ".XXX.XXX"
	BITMAP "..XXX.XX"
	
	BITMAP "..XXX..." ' 13
	BITMAP "..X..X.."
	BITMAP "..X..X.X"
	BITMAP "XXXXXXXX"
	BITMAP "X.XXXX.."
	BITMAP ".XX.XX.X"
	BITMAP "XXX..XXX"
	BITMAP "X......."
	
	BITMAP "..XXX..." ' 14
	BITMAP "..X..X.."
	BITMAP "..X..X.."
	BITMAP ".XXXXXX."
	BITMAP "X.XXXX.X"
	BITMAP "..XXX..."
	BITMAP "...XX..."
	BITMAP "...XXX.."
	
	BITMAP "...XX..." ' 15
	BITMAP "..XXXX.."
	BITMAP "..XXXX.X"
	BITMAP "XXXXXXXX"
	BITMAP "X.XXXX.."
	BITMAP "..X..X.."
	BITMAP "..X..XX."
	BITMAP ".XX....." 
	
	'
	' Calculate player vertical offset due to girder type
	'
get_offset: PROCEDURE
	position = (y/8)*20+((x+4)/8)
	#c=#backtab(position+20)
	
	if #c=GA then offset_y=0:return
	if #c=GB then offset_y=1:return
	if #c=GC then offset_y=2:return
	if #c=GD then offset_y=3:return
	if #c=GE then offset_y=4:return
	offset_y=0
END

	'
	' Controller direction -> 4 way direction conversion table
	'
controller_direction: 
	DATA 0,3,2,3,1,0,2,0 
	DATA 4,4,0,0,1,0,0,0 
	DATA 0,3,2,0,0,0,0,0 
	DATA 4,0,0,0,1,0,0,0 
	
	'
	' Bitmaps for the game (second section)
	'
game_bitmaps_1:
	BITMAP "XX.XX..." ' 16
	BITMAP ".XX.X..."
	BITMAP ".XXXXXXX"
	BITMAP "...XX..X"
	BITMAP "..XXX..X"
	BITMAP ".XXXXXX."
	BITMAP ".X..X..."
	BITMAP ".XX.XX.." 

	 '
	 ' Level definition
	 '
level1_cards:
	DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
	DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,GE,GE,GE,OO,MA,MC,RA,RA,OO,OO,OO
	DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,LA,OO,OO,OO,MB,MD,RA,RA,OO,OO,OO
	DATA OO,OO,OO,OO,GE,GE,GD,GC,GB,GA,GA,GA,GA,GA,GA,GA,GA,OO,OO,OO
	DATA OO,OO,OO,OO,OO,LA,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
	DATA OO,OO,OO,GA,GA,GA,GB,GB,GB,GC,GC,GC,GD,GD,GE,GE,OO,OO,OO,OO
	DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,LA,OO,OO,OO,OO,OO
	DATA OO,OO,OO,OO,GE,GE,GD,GD,GD,GC,GC,GC,GB,GB,GA,GA,GA,OO,OO,OO
	DATA OO,OO,OO,OO,OO,LA,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
	DATA OO,OO,OO,GA,GA,GA,GB,GB,GB,GC,GC,GC,GD,GD,GD,GE,GE,OO,OO,OO
	DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,LA,OO,OO,OO,OO
	DATA OO,OO,GE,GE,GD,GD,GD,GD,GC,GC,GC,GC,GB,GB,GB,GA,GA,GA,OO,OO
