extends Node

export (PackedScene) var Cube
signal game_over
signal win
signal next_level

var rows = 15
var columns = 8
var grid_unit = 48
var number_of_cubes = 3
var board = []
var current_level = 1
var current_direction = 1
var game_over = false

func create_board():
	for y in range(0,rows):
		board.append([])
		for x in range(0,columns):
			var cube = Cube.instance()
			cube.position = Vector2((x*grid_unit)+grid_unit,(y*grid_unit)+grid_unit)
			add_child(cube)
			board[y].append(cube)

func reset():
	number_of_cubes = 3
	current_level = 1
	current_direction = 1
	game_over = false
	$MoveTimer.set_wait_time(0.25)
	for y in range(0,rows):
		for x in range(0,columns):
			board[y][x].turn_off()
	create_cubes_for_level()
	$MoveTimer.start()
			
func _ready():
	create_board()
	create_cubes_for_level()
	$MoveTimer.set_wait_time(0.25)
	$MoveTimer.start()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !game_over:
			$MoveTimer.stop()
			check_for_bad_cubes()
		else:
			game_over = false
			reset()
	
func _on_MoveTimer_timeout():
	for i in range(0, board[rows-current_level].size()-1):
		var index = i
		if current_direction == -1:
			index = (columns-1)-i
				
		if !board[rows-current_level][index].is_on():
			if board[rows-current_level][index+current_direction].is_on():
				board[rows-current_level][index+current_direction].toggle()
				board[rows-current_level][index].toggle()
				
	if board[rows-current_level][0].is_on or board[rows-current_level][columns-1].is_on:
		current_direction *= -1
		
func check_for_bad_cubes():
	if current_level > 1:
		var bad_cubes = []
		for i in range(0, board[rows-current_level].size()):
			if board[rows-current_level][i].is_on() and !board[(rows-current_level)+1][i].is_on():
				bad_cubes.append(board[rows-current_level][i])
				number_of_cubes -= 1
				
		if bad_cubes.size() > 0:
			for i in range(1,columns):
				for cube in bad_cubes:
					cube.toggle()
				yield(get_tree().create_timer(0.1), "timeout")
				
	emit_signal("next_level")

func create_cubes_for_level():
	for i in range(0,number_of_cubes):
		board[rows-current_level][i+3].toggle()

func _on_Board_next_level():
	if number_of_cubes == 0 || current_level == rows:
		game_over = true
		$MoveTimer.stop()
	else:
		current_direction = -1
		if randf() < 0.5:
			current_direction = 1
		current_level += 1
		if (current_level == 4 and number_of_cubes == 3) or (current_level == 8 and number_of_cubes == 2):
			number_of_cubes -= 1
		create_cubes_for_level()
		$MoveTimer.set_wait_time($MoveTimer.get_wait_time() - ($MoveTimer.get_wait_time()*0.11))
		$MoveTimer.start()
