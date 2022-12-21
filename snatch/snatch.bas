' scrapsnatch main file

include "constants.bas"
include "variables.bas"

DEFINE 0,14,GAME_BITMAPS

MODE 1
on frame gosub play_effects
cls

init_game_loop:
gosub init_game

next_level_loop:
gosub next_level
gosub spawn_items
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
else if game_state=GAME_STATE_PROCEED then goto next_level_loop

goto init_game_loop

include "procedures.bas"
include "data.bas"