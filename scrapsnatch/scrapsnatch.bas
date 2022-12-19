' scrapsnatch main file

include "constants.bas"
include "variables.bas"

DEFINE 0,3,GAME_BITMAPS 

cls

#backtab(25)=CHEST
print at 210, CHEST
print at 110,"G"
print at 115,"G"
game_loop:
	wait
	sprite 1, MOB_LEFT+player_x, MOB_TOP+player_y, sprite_player
	sprite 0, MOB_LEFT+enemy_x, MOB_TOP+enemy_y, sprite_enemy
	gosub check_collision
	gosub control_player
	gosub check_player_bg
	gosub print_game_data
	goto game_loop


include "procedures.bas"
include "data.bas"