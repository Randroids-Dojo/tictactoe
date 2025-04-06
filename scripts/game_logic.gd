class_name GameLogic
extends Node

# Core game logic for 3D Tic Tac Toe

# Signals
signal game_over(winner)
signal move_made(position, player)
signal game_reset

# Player enum
enum Player { NONE = 0, X = 1, O = 2 }

# Board state
# Board is a 3×3×3 array (x, y, z coordinates)
var board: Array = []
var current_player: int = Player.X
var game_finished: bool = false
var winner: int = Player.NONE
var move_count: int = 0

func _ready() -> void:
	reset_game()

# Resets the game to starting state
func reset_game() -> void:
	board = []
	
	# Initialize 3D board with empty cells
	for x in range(3):
		var plane = []
		for y in range(3):
			var row = []
			for z in range(3):
				row.append(Player.NONE)
			plane.append(row)
		board.append(plane)
	
	current_player = Player.X
	game_finished = false
	winner = Player.NONE
	move_count = 0
	emit_signal("game_reset")

# Makes a move at the specified position
# Returns true if move was successful
func make_move(x: int, y: int, z: int) -> bool:
	if game_finished:
		return false
		
	if x < 0 or x > 2 or y < 0 or y > 2 or z < 0 or z > 2:
		return false
		
	if board[x][y][z] != Player.NONE:
		return false
	
	board[x][y][z] = current_player
	move_count += 1
	emit_signal("move_made", Vector3(x, y, z), current_player)
	
	# Check win conditions
	if check_win():
		winner = current_player
		game_finished = true
		emit_signal("game_over", winner)
		return true
		
	# Check for draw
	if move_count >= 27: # 3×3×3 board has 27 positions
		game_finished = true
		emit_signal("game_over", Player.NONE) # NONE indicates a draw
		return true
	
	# Switch player
	current_player = Player.O if current_player == Player.X else Player.X
	return true

# Gets the value at a specific position
func get_cell(x: int, y: int, z: int) -> int:
	if x < 0 or x > 2 or y < 0 or y > 2 or z < 0 or z > 2:
		return Player.NONE
	return board[x][y][z]

# Checks if the current player has won
func check_win() -> bool:
	# Check rows in all three dimensions
	for x in range(3):
		for y in range(3):
			if board[x][y][0] == current_player and board[x][y][1] == current_player and board[x][y][2] == current_player:
				return true
	
	for x in range(3):
		for z in range(3):
			if board[x][0][z] == current_player and board[x][1][z] == current_player and board[x][2][z] == current_player:
				return true
	
	for y in range(3):
		for z in range(3):
			if board[0][y][z] == current_player and board[1][y][z] == current_player and board[2][y][z] == current_player:
				return true
	
	# Check the main diagonals in each plane
	for x in range(3):
		if board[x][0][0] == current_player and board[x][1][1] == current_player and board[x][2][2] == current_player:
			return true
		if board[x][0][2] == current_player and board[x][1][1] == current_player and board[x][2][0] == current_player:
			return true
	
	for y in range(3):
		if board[0][y][0] == current_player and board[1][y][1] == current_player and board[2][y][2] == current_player:
			return true
		if board[0][y][2] == current_player and board[1][y][1] == current_player and board[2][y][0] == current_player:
			return true
	
	for z in range(3):
		if board[0][0][z] == current_player and board[1][1][z] == current_player and board[2][2][z] == current_player:
			return true
		if board[0][2][z] == current_player and board[1][1][z] == current_player and board[2][0][z] == current_player:
			return true
	
	# Check the four main diagonals of the cube
	if board[0][0][0] == current_player and board[1][1][1] == current_player and board[2][2][2] == current_player:
		return true
	if board[0][0][2] == current_player and board[1][1][1] == current_player and board[2][2][0] == current_player:
		return true
	if board[0][2][0] == current_player and board[1][1][1] == current_player and board[2][0][2] == current_player:
		return true
	if board[0][2][2] == current_player and board[1][1][1] == current_player and board[2][0][0] == current_player:
		return true
	
	return false

# Returns current player as string
func get_current_player_string() -> String:
	return "X" if current_player == Player.X else "O"

# Returns winner as string
func get_winner_string() -> String:
	match winner:
		Player.NONE:
			return "Draw"
		Player.X:
			return "X"
		Player.O:
			return "O"
	return ""