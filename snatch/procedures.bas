print_game_data: PROCEDURE
	print at 0 color 7,<5>#score,"0"
end

draw_sprites: PROCEDURE
	
	if shot_on>0 then
		sprite 1, MOB_LEFT+shot_x, MOB_TOP+shot_y, $0800 + (frame_cnt%6) + shot_on * 8
	end if
	
	sprite 2, MOB_LEFT+enemy_x, MOB_TOP+enemy_y, $0802 + (3+enemy_frame) * 8
	sprite 0, MOB_LEFT+player_x, MOB_TOP+player_y, $0801 + player_frame * 8
	
	frame_cnt=frame_cnt+1
	if frame_cnt%10=0 then 
		enemy_frame=enemy_frame+1
		if enemy_frame > 2 then enemy_frame=0
	end if
end

check_collision: PROCEDURE
	if COL1 and $0001 then 
		'print at 220, <3>player_x
	else 
		'print at 220, <3>""
	end if
end

check_player_bg: PROCEDURE
	x=(player_x+4)/8
	y=(player_y+4)/8
	bg=#backtab(y*20+x-21)

	if #backtab(y*20+x-21)=CHEST or bg=63 then
		print at 230, <3>(y*20+x-21)
		print at 236, <3>bg
		#backtab(y*20+x-21)=0
	else
		print at 230, <3>0
		print at 236, <3>bg
	end if
end

control_player: PROCEDURE
	c = cont
	if (d=$80)+(d=$40)+(d=$20) then
		' keypad pressed
	else
		if (d=$60)+(d=$a0)+(d=$c0) then ' side button pressed
		end if
				
		if cont1.up and player_y>MIN_Y then player_y=player_y-1
		if cont1.down and player_y<MAX_Y then player_y=player_y+1
		if cont1.left and player_x>MIN_X then player_x=player_x-1 
		if cont1.right and player_x<MAX_X then player_x=player_x+1	
		
		if (cont1.up or cont1.down or cont1.left or cont1.right) and frame_cnt%4=0 then
			player_frame=player_frame+1
			if player_frame>2 then player_frame=0
		end if
	end if
end

move_enemy: PROCEDURE
	if enemy_horizontal=ENEMY_E and enemy_x+enemy_speed>MAX_X then
		enemy_horizontal=ENEMY_W
	elseif enemy_horizontal=ENEMY_W and enemy_x-enemy_speed<MIN_X then
		enemy_horizontal=ENEMY_E	
	end if

	if enemy_vertical=ENEMY_S and enemy_y+enemy_speed>MAX_Y then
		enemy_vertical=ENEMY_N
	elseif enemy_vertical=ENEMY_N and enemy_y-enemy_speed<MIN_Y then
		enemy_vertical=ENEMY_S	
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
		if 2-level>0 then 
			accu=5-level
		else
			accu=1
		end if	
		print at 220, <3>random(0,accu)
		
		if random(0,accu)>0 then return
		
		shot_on=7
		shot_x=enemy_x:shot_y=enemy_y
		
		if player_x<enemy_x then 
			shot_dir=SHOT_W
		else
			shot_dir=SHOT_E
		end if
	elseif player_x=enemy_x then
		if 2-level>0 then 
			accu=5-level
		else
			accu=1
		end if	
		print at 220, <3>accu
		if random(0,accu)>0 then return
		shot_on=6
		shot_x=enemy_x:shot_y=enemy_y
		
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
	end if
end

