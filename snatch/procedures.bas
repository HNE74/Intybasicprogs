print_game_data: PROCEDURE
	print at 0 color 7,<5>#score,"0"
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
		
		d=controller_direction(c and $1F)
		print at 224, <2>d
		if d=DISK_N and player_y>MIN_Y then 
			player_y=player_y-1
		elseif d=DISK_S and player_y<MAX_Y then 
			player_y=player_y+1
		elseif d=DISK_W and player_x>MIN_X then 
			player_x=player_x-1 		
		elseif d=DISK_E and player_x<MAX_X then 
			player_x=player_x+1	
	    elseif d=DISK_NE and player_y>MIN_Y and player_x<MAX_X then 
			player_y=player_y-1:player_x=player_x+1 
		elseif d=DISK_SE and player_y<MAX_Y and player_x<MAX_X  then 
			player_y=player_y+1:player_x=player_x+1
		elseif d=DISK_NW and player_y>MIN_Y and player_x>MIN_X then 
			player_y=player_y-1:player_x=player_x-1 
		elseif d=DISK_SW and player_y<MAX_Y and player_x>MIN_X then 
			player_y=player_y+1:player_x=player_x-1 			
		end if	
	end if
end
