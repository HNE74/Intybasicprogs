


CONST SPRITE_PLAYER = $0801 + 0 * 8 
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

DEFINE 0,1,player 

cls
game_loop:
	wait
	sprite 0, MOB_LEFT+player_x, MOB_TOP+player_y, sprite_player	
	gosub control_player
	goto game_loop


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
		
		' player horizontal movement
		print at 220, <3>player_x
		if (c and $1F)=DISK_N and player_y>MIN_Y then 
			player_y=player_y-1
		elseif (c and $1F)=DISK_NW then 
			player_y=player_y-1:player_x=player_x-1 		
		elseif (c and $1F)=DISK_NE then 
			player_y=player_y-1:player_x=player_x+1 
		elseif (c and $1F)=DISK_S and player_y<MAX_Y then 
			player_y=player_y+1
		elseif (c and $1F)=DISK_SW then 
			player_y=player_y+1:player_x=player_x-1 		
		elseif (c and $1F)=DISK_SE then 
			player_y=player_y+1:player_x=player_x+1 		
		elseif (c and $1F)=DISK_W and player_x>MIN_X then 
			player_x=player_x-1 		
		elseif (c and $1F)=DISK_E and player_x<MAX_X then 
			player_x=player_x+1	
		end if	
	
	end if
end



player: 
 BITMAP "..XXXX.." 
 BITMAP ".X....X." 
 BITMAP "X.X..X.X" 
 BITMAP "X......X"
 BITMAP "X.X..X.X" 
 BITMAP "X..XX..X" 
 BITMAP ".X....X." 
 BITMAP "..XXXX.."