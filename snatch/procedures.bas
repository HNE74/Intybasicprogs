print_score: PROCEDURE
	print at 1 color 6,<6>#score
end

clear_arena: PROCEDURE
	for accu=0 to 2
		sprite accu,0
	next accu

	for accu=0 to 10
		print at accu*20+20 color 7, "                    "
	next accu
end

init_game: PROCEDURE
	#score=0
	level=0
	lives=3
	shields=3
	player_items=0
end

init_main_loop: PROCEDURE
	player_x=20
	player_y=20
	player_frame=0
	player_shield_on=0
	player_shield_cnt=0

	enemy_x=random(50)+70
	enemy_y=random(50)+30
	enemy_speed=1
	enemy_frame=0
	enemy_horizontal=ENEMY_E
	enemy_vertical=ENEMY_S
	
	shot_on=0
	gosub print_shields_left
	gosub print_lives_left
end

print_lives_left: PROCEDURE
	print at 16, "    "
    if lives > 1 then	
		for accu=1 to lives-1
			#backtab(19-accu)=$0801+2*8
		next accu
	end if	
end

print_shields_left: PROCEDURE
	print at 10, "    "
    if shields > 0 then	
		for accu=1 to shields
			#backtab(13-accu)=$0807+14*8
		next accu
	end if	
end

spawn_items: PROCEDURE
	for accu=0 to 8+level
place_item:
		player_items=random(220)+20
		if #backtab(player_items)=BLANK then
			#backtab(player_items)=CHEST
		else
			goto place_item
		end if
	next accu
	
	if level%5=0 and lives<3 then
place_live:
		player_items=random(220)+20
		if #backtab(player_items)=BLANK then
			#backtab(player_items)=LIVE
		else
			goto place_live
		end if
	end if

	if level%3=0 and shields<3 then
place_shield:
		player_items=random(220)+20
		if #backtab(player_items)=BLANK then
			#backtab(player_items)=SHIELD
		else
			goto place_shield
		end if
	end if
		
	player_items=0
end

draw_sprites: PROCEDURE	
	if shot_on>0 then
		sprite 1, MOB_LEFT+shot_x, MOB_TOP+shot_y, $0800 + (frame_cnt%6) + shot_on * 8
	end if
	
	sprite 2, MOB_LEFT+enemy_x, MOB_TOP+enemy_y, $0802 + (3+enemy_frame) * 8
	
	accu=1
	if player_shield_on then accu=7
	sprite 0, MOB_LEFT+player_x, MOB_TOP+player_y, $0800 + accu + player_frame * 8
	
	frame_cnt=frame_cnt+1
	if frame_cnt%10=0 then 
		enemy_frame=enemy_frame+1
		if enemy_frame > 2 then enemy_frame=0
	end if
end

check_collision: PROCEDURE
	if col0 and $0006 then
		if player_shield_on=0 then
			game_state=GAME_STATE_DEAD
		else
			shot_on=0
			sprite 1,0
			gosub sound_none
		end if
	end if
end

check_player_bg: PROCEDURE
	x=(player_x+4)/8
	y=(player_y+4)/8
	bg=#backtab(y*20+x-21)

	if #backtab(y*20+x-21)=CHEST then
		sound_effect=SOUND_EFFECT_SNATCH
		#score=#score+10
		#backtab(y*20+x-21)=0
		player_items=player_items+1
		gosub sound_none
		if player_items=9+level then game_state=GAME_STATE_PROCEED
    elseif #backtab(y*20+x-21)=SHIELD then
		sound_effect=SOUND_EFFECT_SNATCH
		shields=shields+1
		#backtab(y*20+x-21)=0
		gosub print_shields_left
		gosub sound_none
    elseif #backtab(y*20+x-21)=LIVE then
		sound_effect=SOUND_EFFECT_SNATCH
		lives=lives+1
		#backtab(y*20+x-21)=0
		gosub print_lives_left
		gosub sound_none	
	end if
end

control_player: PROCEDURE			
	if cont1.up and player_y>MIN_Y then player_y=player_y-1
	if cont1.down and player_y<MAX_Y then player_y=player_y+1
	if cont1.left and player_x>MIN_X then player_x=player_x-1 
	if cont1.right and player_x<MAX_X then player_x=player_x+1	
	
	if (cont1.up or cont1.down or cont1.left or cont1.right) and frame_cnt%4=0 then
		player_frame=player_frame+1
		if player_frame>2 then player_frame=0
	end if
	
	if cont1.button and player_shield_on=0 and shields>0 then
		sound_effect=SOUND_EFFECT_SHIELD
		player_shield_cnt=200
		player_shield_on=1
		shields=shields-1
		gosub print_shields_left
	end if
end

manage_player_shield: PROCEDURE
	if player_shield_cnt > 0 and player_shield_on>0 then
		player_shield_cnt=player_shield_cnt-1
	else
		player_shield_on=0
	end if
end

move_enemy: PROCEDURE
	if enemy_horizontal=ENEMY_E and enemy_x+enemy_speed>MAX_X then
		enemy_horizontal=ENEMY_W
		if sound_effect<>SOUND_EFFECT_SHOT then
			gosub sound_none
			sound_effect=SOUND_EFFECT_BUMP
		end if
	elseif enemy_horizontal=ENEMY_W and enemy_x-enemy_speed<MIN_X then
		enemy_horizontal=ENEMY_E
		if sound_effect<>SOUND_EFFECT_SHOT then
			gosub sound_none
			sound_effect=SOUND_EFFECT_BUMP
		end if	
	end if

	if enemy_vertical=ENEMY_S and enemy_y+enemy_speed>MAX_Y then
		enemy_vertical=ENEMY_N
		if sound_effect<>SOUND_EFFECT_SHOT then
			gosub sound_none
			sound_effect=SOUND_EFFECT_BUMP
		end if
	elseif enemy_vertical=ENEMY_N and enemy_y-enemy_speed<MIN_Y then
		enemy_vertical=ENEMY_S
		if sound_effect<>SOUND_EFFECT_SHOT then
			gosub sound_none
			sound_effect=SOUND_EFFECT_BUMP
		end if
	end if

	if enemy_horizontal=ENEMY_E then 
		enemy_x=enemy_x+enemy_speed
	else
		enemy_x=enemy_x-enemy_speed	
	end if
	
	if enemy_vertical=ENEMY_S then 
		enemy_y=enemy_y+enemy_speed
	else
		enemy_y=enemy_y-enemy_speed	
	end if		
end

control_shot: PROCEDURE
	if shot_on>0 then gosub move_shot:return
	
	if player_y=enemy_y then 
		if 10-level>0 then 
			accu=MIN_DIFFICULTY-level
		else
			accu=1
		end if		
		if rand(accu)>0 then return
		
		shot_on=7
		shot_x=enemy_x:shot_y=enemy_y
		gosub sound_none
		sound_effect=SOUND_EFFECT_SHOT
		
		if player_x<enemy_x then 
			shot_dir=SHOT_W
		else
			shot_dir=SHOT_E
		end if
	elseif player_x=enemy_x then
		if 10-level>0 then 
			accu=MIN_DIFFICULTY-level
		else
			accu=1
		end if	
		if rand(accu)>0 then return
		
		shot_on=6
		shot_x=enemy_x:shot_y=enemy_y
		gosub sound_none
		sound_effect=SOUND_EFFECT_SHOT
		
		if player_y<enemy_y then 
			shot_dir=SHOT_N
		else
			shot_dir=SHOT_S
		end if		
	end if
end

move_shot: PROCEDURE		
	if shot_x>MIN_X and shot_x<MAX_X and shot_y>MIN_Y and shot_y<MAX_Y then
		if shot_dir=SHOT_N then 
			shot_y=shot_y-SHOT_SPEED
		elseif shot_dir=SHOT_S then 
			shot_y=shot_y+SHOT_SPEED
		elseif shot_dir=SHOT_W then 
			shot_x=shot_x-SHOT_SPEED
		elseif shot_dir=SHOT_E then 
			shot_x=shot_x+SHOT_SPEED
		end if
	else
		shot_on=0
		sprite 1,0
		gosub sound_none
		sound_effect=SOUND_EFFECT_NONE
	end if
end

player_dead: PROCEDURE
	gosub sound_none
	for player_frame=0 to 3
		sprite 0, MOB_LEFT+player_x, MOB_TOP+player_y, $0801+(9+player_frame) * 8	
		for accu=0 to 20
			sound 0,1000+(accu/4%2)*500,10
			wait
		next accu
	next player_frame
	gosub sound_none
	
	for accu=0 to 2:sprite accu,0:next accu

	lives=lives-1	
	if lives=0 then 
		game_state=GAME_STATE_OVER	
	else
		game_state=GAME_STATE_MAIN
	end if
end

next_level: PROCEDURE
	gosub clear_arena
	gosub print_score
	gosub print_lives_left
	gosub print_shields_left
	if player_items>0 then 
		print at 81 color 5, <3>player_items
		print at 85 color 5, "ITEMS SNATCHED"
	end if

	player_items=0
	level=level+1	
	
	print at 121 color 6, "STARTING LEVEL"
	print at 136 color 6, <3>level
	for accu=0 to 180
		sound 0,rand(accu)*10,10
		wait
	next accu
	gosub clear_arena
end

game_over: PROCEDURE
	cls
	print at 85 color 6, "GAME OVER"
	print at 121 color 5, "FINAL SCORE"
	print at 133 color 5,<6>#score
	
	if #score>#high then
		#high=#score
		print at 163 color 2, "NEW HIGHSCORE!"
	end if

	for accu=0 to 200:wait:next accu	
end

title_screen: PROCEDURE
	cls
	print at 66 color 6, "SNATCH"
 	print at 101 color 5, "(C)NOLTISOFT 2022"
	print at 142 color 2, "HIGHSCORE"
	print at 152 color 2,<6>#high	
 	print at 182 color 7, "BUTTON TO START"
	
	do 
	loop until cont1.button>0
end

play_effects: PROCEDURE
	on sound_effect gosub sound_none, sound_snatch, sound_shot, sound_bump, sound_shield
end

sound_none: PROCEDURE
	sound_state=0
	sound 0,,0
	sound 4,,$38
end

sound_snatch: PROCEDURE
	sound 0,220-sound_state*20,10
	sound_state=sound_state+1
	if sound_state=10 then sound_effect=0:sound_state=0
end

sound_shot: PROCEDURE
	sound 0,2000,15
	sound 4,sound_state,$30
	sound_state=sound_state+1
	if sound_state=10 then sound_effect=0:sound_state=0
end

sound_bump: PROCEDURE
	sound 0,250-sound_state*2,8
	sound_state=sound_state+1
	if sound_state=5 then sound_effect=0:sound_state=0
end

sound_shield: PROCEDURE
	sound 0,2000-sound_state*1/4,10
	sound_state=sound_state+1
	if sound_state=10 then sound_effect=0:sound_state=0
end


