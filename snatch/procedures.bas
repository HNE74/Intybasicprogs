print_game_data: PROCEDURE
	print at 0 color 7,<5>#score,"0"
end

draw_sprites: PROCEDURE
	sprite 1, MOB_LEFT+player_x, MOB_TOP+player_y, sprite_player
	sprite 0, MOB_LEFT+enemy_x, MOB_TOP+enemy_y, sprite_enemy
end

check_collision: PROCEDURE
	if COL1 and $0001 then 
		print at 220, <3>player_x
	else 
		print at 220, <3>""
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

