	'
	' Monkey moon
	' by Oscar Toledo G.
	' Creation date: Jun/11/2018.
	'
	
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
	CLS
	MODE 0,0,0,0,0
	WAIT
	DEFINE 0,16,game_bitmaps_0
	WAIT
	DEFINE 16,1,game_bitmaps_1
	WAIT
	
	' Game
start_game:

restart_level:
	CLS
	SCREEN LEVEL1_CARDS
	
	FOR C=0 TO 6
		SPRITE C, 0
	NEXT C
	SPRITE 7,MOB_LEFT+13*8+4, MOB_TOP+1*8,MF ' MONKEY FACE COLOR
	
	' INIT PLAYER
	PLAYER_X=16 
	PLAYER_Y=80
	PLAYER_STATE=0
	
	'
	' Loop for the game
	'
game_loop:
	x=player_x
	y=player_y
	
	' check adjust player horizontal position
	if player_state<>2 and player_state<>6 then
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
	
	c=cont
    d=c and $e0
	if (d=$80) + (d=$40) + (d=$20) then
		' keypad pressed
	elseif (d=$60) + (d=$a0) + (d=$c0) then
		' side button pressed
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
