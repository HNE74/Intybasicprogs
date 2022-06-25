' 
 ' Space Raider 
 ' by Oscar Toledo G. 
 ' modified by Noltisoft
 ' Creation date: Jun/11/2018. 
 ' 
UNSIGNED #score 
CONST STAR = $000E * 8 + 2 
CONST SPRITE_PLAYER = $0807 + 0 * 8 
CONST SPRITE_SHOT1 = $0805 + 1 * 8 
CONST SPRITE_SHOT2 = $1805 + 2 * 8 
CONST SPRITE_EXPLOSION = $1800 + 3 * 8 
CONST SPRITE_SHIP_1 = $0805 + 4 * 8 
CONST SPRITE_SHIP_2 = $0805 + 5 * 8 
CONST SPRITE_SHIP_3 = $0805 + 6 * 8 
CONST SPRITE_SHIP_4 = $0805 + 7 * 8 
CONST SPRITE_SHIP_5 = $0805 + 8 * 8 
CONST SPRITE_SHIP_6 = $0805 + 9 * 8 
CONST SPRITE_SHIP_7 = $0805 + 10 * 8 
CONST SPRITE_SHIP_8 = $0805 + 11 * 8 
CONST MOB_LEFT = $0300 
CONST MOB_TOP = $0100 
DIM stars(20) 
 
DIM ex(6) 
DIM ey(6) 
DIM ef(6) 
DIM es(6) 
CLS 
MODE 0,0,0,0,0 
WAIT 
DEFINE 0,12,game_bitmaps 
WAIT 

start_game: 
	cls
	
	'
	' Init star background
	'
	for c=0 to 19
		stars(c) = (random(11)+1) * 20 + c
		#backtab(stars(c))=STAR
	next c

'
' Main game loop
'	
game_loop:
	'
	' synchronize game
	'
	wait
	
	'
	' move stars backdrop, 10 stars are updated per loop iteration
	' dependent on frame is even or odd
	'
	c=frame and 1
	start=c*10
	last=start+9
	for c=start to last
		d=stars(c)
		#backtab(d)=0
		if d>=220 then 
			if random(2) then
				d=d-180
			else
				d=d-200
			end if
		else
			d=d+20
		end if
		#backtab(d)=star
		stars(c)=d
	next c
	
	goto game_loop
	
	
	
' 
' Bitmaps used for game 
' 
game_bitmaps: 
	BITMAP "...XX..."
	BITMAP "..XXXX.." 
	BITMAP "..X..X.." 
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXXXXXX" 
	BITMAP ".XX..XX." 
	BITMAP ".X....X."
	
	BITMAP "........" 
	BITMAP "........" 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "........" 
	BITMAP "...X...." 
	
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "........" 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "...X...." 
	BITMAP "........" 
	
	BITMAP "...X..X." 
	BITMAP ".X.X.XX." 
	BITMAP "XX.X...." 
	BITMAP ".....X.X" 
	BITMAP ".......X" 
	BITMAP ".X.X...." 
	BITMAP "X....X.." 
	BITMAP "...X..X."
	
	BITMAP "..X..X.." 
	BITMAP ".XX..XX." 
	BITMAP "XXX..XXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXX..XXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXX..." 
	BITMAP "XXXX...X" 
	BITMAP "XXXXX.XX" 
	BITMAP "XX.XXXXX" 
	BITMAP "XXX.XXXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXXXXXX" 
	BITMAP "XX.XX..." 
	BITMAP "XX.XX..." 
	BITMAP "XXXXXXXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.."
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXX.XXXX" 
	BITMAP "XX.XXXXX" 
	BITMAP "XXXXX.XX" 
	BITMAP "XXXX...X" 
	BITMAP ".XXXX..." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXX..XXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXXXXXXX" 
	BITMAP "XXX..XXX" 
	BITMAP ".XX..XX." 
	BITMAP "..X..X.."
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXX.XXX" 
	BITMAP "XXXXX.XX" 
	BITMAP "XX.XXXXX" 
	BITMAP "X...XXXX" 
	BITMAP "...XXXX." 
	BITMAP "..XXXX.."
	
	BITMAP "..XXXX.." 
	BITMAP ".XXXXXX." 
	BITMAP "XXXXXXXX" 
	BITMAP "...XX.XX" 
	BITMAP "...XX.XX" 
	BITMAP "XXXXXXXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.." 
	
	BITMAP "..XXXX.." 
	BITMAP "...XXXX." 
	BITMAP "X...XXXX" 
	BITMAP "XX.XXXXX" 
	BITMAP "XXXXX.XX" 
	BITMAP "XXXX.XXX" 
	BITMAP ".XXXXXX." 
	BITMAP "..XXXX.."	
	