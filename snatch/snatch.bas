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
	gosub draw_sprites	
	gosub check_collision
	gosub control_player
	gosub move_enemy
	gosub check_player_bg
	gosub print_game_data
	wait
	goto game_loop


include "procedures.bas"
include "data.bas"