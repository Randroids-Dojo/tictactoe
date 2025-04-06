extends Node3D

# Main controller for the 3D Tic Tac Toe game

# Node references
@onready var game_logic: GameLogic = GameLogic.new()
@onready var status_label: Label = $UI/HeaderPanel/Label
@onready var reset_button: Button = $UI/FooterPanel/ResetButton
@onready var win_label: Label = $UI/WinLabel

# Board properties
var cells: Array = []
var cell_size: float = 3.0
var cell_spacing: float = 2.0

# Materials
var x_material: StandardMaterial3D
var o_material: StandardMaterial3D
var empty_cell_material: StandardMaterial3D

func _ready() -> void:
	# Initialize game components
	_setup_game_logic()
	_setup_ui()
	_create_materials()
	_create_board()
	_update_ui()

func _setup_game_logic() -> void:
	# Add game logic to scene tree
	add_child(game_logic)
	
	# Connect signals from game logic
	game_logic.move_made.connect(_on_move_made)
	game_logic.game_over.connect(_on_game_over)
	game_logic.game_reset.connect(_on_game_reset)

func _setup_ui() -> void:
	# Connect UI signals
	reset_button.pressed.connect(_on_reset_pressed)
	
	# Hide win label initially
	if win_label:
		win_label.visible = false

func _create_materials() -> void:
	# Empty cell material - glass-like appearance
	empty_cell_material = StandardMaterial3D.new()
	empty_cell_material.albedo_color = Color(0.9, 0.95, 1.0, 0.6)
	empty_cell_material.metallic = 0.3
	empty_cell_material.roughness = 0.05
	empty_cell_material.emission_enabled = true
	empty_cell_material.emission = Color(0.7, 0.8, 0.9)
	empty_cell_material.emission_energy_multiplier = 0.3
	empty_cell_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	# X material - red with glow
	x_material = StandardMaterial3D.new()
	x_material.albedo_color = Color(1.0, 0.15, 0.15)
	x_material.metallic = 0.8
	x_material.roughness = 0.2
	x_material.emission_enabled = true
	x_material.emission = Color(1.0, 0.3, 0.2)
	x_material.emission_energy_multiplier = 2.5
	
	# O material - blue with glow
	o_material = StandardMaterial3D.new()
	o_material.albedo_color = Color(0.1, 0.4, 1.0)
	o_material.metallic = 0.8
	o_material.roughness = 0.2
	o_material.emission_enabled = true
	o_material.emission = Color(0.2, 0.5, 1.0)
	o_material.emission_energy_multiplier = 2.5

func _create_board():
	cells = []
	
	# Create 3D grid of cells
	for x in range(3):
		var plane = []
		for y in range(3):
			var row = []
			for z in range(3):
				# Create cell
				var cell_root = StaticBody3D.new()
				cell_root.position = Vector3(
					(x - 1) * (cell_size + cell_spacing), 
					(y - 1) * (cell_size + cell_spacing), 
					(z - 1) * (cell_size + cell_spacing)
				)
				cell_root.collision_layer = 1
				
				# Add collision shape for click detection
				var collision = CollisionShape3D.new()
				var box_shape = BoxShape3D.new()
				box_shape.size = Vector3(cell_size, cell_size, cell_size)
				collision.shape = box_shape
				cell_root.add_child(collision)
				
				# Create visual representation
				var cell = CSGSphere3D.new()
				cell.radius = cell_size * 0.5
				cell.smooth_faces = true
				cell.material = empty_cell_material
				
				cell_root.add_child(cell)
				
				# Store position data
				cell_root.set_meta("cell_position", Vector3i(x, y, z))
				cell_root.name = "Cell_" + str(x) + "_" + str(y) + "_" + str(z)
				
				add_child(cell_root)
				row.append(cell_root)
			plane.append(row)
		cells.append(plane)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_check_mouse_click()

func _check_mouse_click():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	if camera:
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.new()
		query.from = ray_origin
		query.to = ray_origin + ray_direction * 100
		query.collision_mask = 1
		
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider is StaticBody3D and result.collider.has_meta("cell_position"):
				var pos = result.collider.get_meta("cell_position")
				_on_cell_clicked(pos)
		else:
			# Fallback: find closest cell
			var closest_distance = 1000000.0
			var closest_cell = null
			
			for x in range(3):
				for y in range(3):
					for z in range(3):
						var cell = cells[x][y][z]
						var cell_pos = cell.position
						var distance = _distance_point_to_line(cell_pos, ray_origin, ray_direction)
						
						if distance < closest_distance:
							closest_distance = distance
							closest_cell = cell
							
			if closest_distance < 3.0 and closest_cell != null:
				var pos = closest_cell.get_meta("cell_position")
				_on_cell_clicked(pos)

# Helper function to calculate distance from point to line
func _distance_point_to_line(point, line_start, line_dir):
	var v = point - line_start
	var projlen = v.dot(line_dir)
	var projpoint = line_start + line_dir * projlen
	return (point - projpoint).length()

func _on_cell_clicked(pos: Vector3i) -> void:
	game_logic.make_move(pos.x, pos.y, pos.z)
	_update_ui()

func _on_move_made(position: Vector3, player: int) -> void:
	update_cell(position, player)
	_update_ui()

func update_cell(position: Vector3, player: int) -> void:
	if position.x < 0 or position.x > 2 or position.y < 0 or position.y > 2 or position.z < 0 or position.z > 2:
		return
	
	var cell_root = cells[position.x][position.y][position.z]
	var cell = cell_root.get_child(1)  # The CSGSphere3D is the second child
	
	if player == GameLogic.Player.X:
		cell.material = x_material
	elif player == GameLogic.Player.O:
		cell.material = o_material
	else:
		cell.material = empty_cell_material

func _on_game_over(winner: int) -> void:
	var message: String = ""
	match winner:
		GameLogic.Player.NONE:
			message = "Game Over - Draw!"
		GameLogic.Player.X:
			message = "Game Over - X Wins!"
		GameLogic.Player.O:
			message = "Game Over - O Wins!"
	
	status_label.text = message
	
	# Show win message
	if win_label:
		win_label.text = message
		win_label.visible = true
		
		# Animation for win label
		var tween = create_tween()
		tween.tween_property(win_label, "modulate:a", 1.0, 0.5)
		tween.tween_property(win_label, "scale", Vector2(1.2, 1.2), 0.3)
		tween.tween_property(win_label, "scale", Vector2(1.0, 1.0), 0.3)

func _on_game_reset() -> void:
	for x in range(3):
		for y in range(3):
			for z in range(3):
				update_cell(Vector3(x, y, z), GameLogic.Player.NONE)
	
	# Hide win label
	if win_label:
		win_label.visible = false
	
	_update_ui()

func _on_reset_pressed() -> void:
	game_logic.reset_game()

func _update_ui() -> void:
	var current_player_text = game_logic.get_current_player_string()
	status_label.text = "3D Tic Tac Toe - Current Turn: " + current_player_text