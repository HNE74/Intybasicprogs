' scrapsnatch main file

include "constants.bas"
include "variables.bas"

DEFINE 0,14,GAME_BITMAPS

MODE 1
cls

#backtab(25)=CHEST
print at 210, CHEST
print at 110,"G"
print at 115,"G"

game_state = GAME_STATE_MAIN

main_loop:
gosub init_main_loop
while game_state = GAME_STATE_MAIN
	gosub draw_sprites	
	gosub control_player
	gosub move_enemy
	gosub control_shot
	gosub check_player_bg
	gosub print_game_data
	gosub check_collision	
	wait
wend

while game_state=GAME_STATE_DEAD
	gosub player_dead
wend
if game_state=GAME_STATE_MAIN then goto main_loop

include "procedures.bas"
include "data.bas"