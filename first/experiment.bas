


CONST SPRITE_PLAYER = $0801 + 0 * 8 
CONST SPRITE_ENEMY = $0802 + 1 * 8
CONST CHEST = $0803 + 2 * 8
CONST MOB_LEFT = $0300 
CONST MOB_TOP = $0100 

CONST DISK_N = 4
CONST DISK_NE = 22
CONST DISK_NW = 28
CONST DISK_S = 1
CONST DISK_SE = 19
CONST DISK_SW = 25
CONST DISK_E = 2
CONST DISK_W = 8

CONST MIN_X = 8
CONST MAX_X = 159
CONST MIN_Y = 8
CONST MAX_Y = 96

player_x=20
player_y=20

enemy_x=100
enemy_y=80

DEFINE 0,3,GAME_BITMAPS 

cls

#backtab(25)=CHEST
print at 110,"G"
print at 115,"G"
game_loop:
	wait
	sprite 1, MOB_LEFT+player_x, MOB_TOP+player_y, sprite_player
	sprite 0, MOB_LEFT+enemy_x, MOB_TOP+enemy_y, sprite_enemy	
	gosub check_collision
	gosub control_player
	gosub check_player_bg
	goto game_loop


check_collision: PROCEDURE
	if COL1 and $0001 then 
		print at 220, <3>player_x
	else 
		print at 220, <3>
	end if
end

check_player_bg: PROCEDURE
	x=(player_x+4)/8
	y=(player_y+4)/8
	bg=#backtab(y*20+x-21)
	print at 210, CHEST
	if #backtab(y*20+x-21)=CHEST or bg=63 then
		print at 230, <3>(y*20+x-21)
		print at 236, <3>bg
	else
		print at 230, <3>0
		print at 236, <3>bg
	end if
end

control_player: PROCEDURE
	'
	' player management
	'
	c = cont
	d = c and $e0
	if (d=$80)+(d=$40)+(d=$20) then
		' keypad pressed
	else
		if (d=$60)+(d=$a0)+(d=$c0) then ' side button pressed
		end if
		
		if (c and $1F)=DISK_N and player_y>MIN_Y then 
			player_y=player_y-1
		elseif (c and $1F)=DISK_NW and player_y>MIN_Y and player_x>MIN_X then 
			player_y=player_y-1:player_x=player_x-1 		
		elseif (c and $1F)=DISK_NE and player_y>MIN_Y and player_x<MAX_X then 
			player_y=player_y-1:player_x=player_x+1 
		elseif (c and $1F)=DISK_S and player_y<MAX_Y then 
			player_y=player_y+1
		elseif (c and $1F)=DISK_SW and player_y<MAX_Y and player_x>MIN_X then 
			player_y=player_y+1:player_x=player_x-1 		
		elseif (c and $1F)=DISK_SE and player_y<MAX_Y and player_x<MAX_X  then 
			player_y=player_y+1:player_x=player_x+1 		
		elseif (c and $1F)=DISK_W and player_x>MIN_X then 
			player_x=player_x-1 		
		elseif (c and $1F)=DISK_E and player_x<MAX_X then 
			player_x=player_x+1	
		end if	
	
	end if
end

GAME_BITMAPS: 
 BITMAP "..XXXX.." 
 BITMAP ".X....X." 
 BITMAP "X.X..X.X" 
 BITMAP "X......X"
 BITMAP "X.X..X.X" 
 BITMAP "X..XX..X" 
 BITMAP ".X....X." 
 BITMAP "..XXXX.."

 BITMAP "..XXXX.." 
 BITMAP ".X....X." 
 BITMAP "X.X..X.X" 
 BITMAP "X......X"
 BITMAP "X..XX..X" 
 BITMAP "X.X..X.X" 
 BITMAP ".X....X." 
 BITMAP "..XXXX.."
 
 BITMAP "...XXXXX"
 BITMAP "..X...XX"
 BITMAP ".X...X.X"
 BITMAP "XXXXX..X"
 BITMAP "X...X..X"
 BITMAP "X...X.X."
 BITMAP "X...XX.."
 BITMAP "XXXXX..."
 
