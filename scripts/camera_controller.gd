extends Camera3D

# Camera controller for the 3D tic-tac-toe game
# Handles orbital camera movement, zoom, and input

# Camera settings
var orbit_speed: float = 0.005
var zoom_speed: float = 0.5
var min_zoom: float = 5.0
var max_zoom: float = 40.0
var auto_rotate: bool = true
var auto_rotate_speed: float = 0.1

# Camera state
var target_position: Vector3 = Vector3.ZERO
var orbit_rotation: Vector2 = Vector2(0.5, 0.0)  # Initial camera angle
var current_distance: float = 30.0  # Camera distance from target

func _ready() -> void:
	_update_camera_position()

func _process(delta: float) -> void:
	# Auto-rotate when not being controlled
	if auto_rotate and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		orbit_rotation.y -= delta * auto_rotate_speed * 0.05
		_update_camera_position()

func _input(event: InputEvent) -> void:
	# Right mouse button drag for orbit
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		orbit_rotation.x -= event.relative.y * orbit_speed
		orbit_rotation.y -= event.relative.x * orbit_speed
		
		# Limit vertical rotation
		orbit_rotation.x = clamp(orbit_rotation.x, -1.0, 1.0)
		
		auto_rotate = false
		_update_camera_position()
	
	# Mouse wheel zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_distance = max(min_zoom, current_distance - zoom_speed)
			_update_camera_position()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_distance = min(max_zoom, current_distance + zoom_speed)
			_update_camera_position()
		
		# Re-enable auto-rotation after releasing right mouse button
		if event.button_index == MOUSE_BUTTON_RIGHT and !event.pressed:
			await get_tree().create_timer(3.0).timeout
			if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				auto_rotate = true
			
	# Trackpad pinch to zoom
	if event is InputEventMagnifyGesture:
		var zoom_change = (event.factor - 1.0) * 5.0
		current_distance = clamp(current_distance - zoom_change, min_zoom, max_zoom)
		_update_camera_position()
		
	# Trackpad pan gesture for rotation
	if event is InputEventPanGesture:
		if Input.is_key_pressed(KEY_ALT) or Input.is_key_pressed(KEY_META):
			orbit_rotation.x -= event.delta.y * orbit_speed * 10.0
			orbit_rotation.y -= event.delta.x * orbit_speed * 10.0
			
			orbit_rotation.x = clamp(orbit_rotation.x, -1.0, 1.0)
			
			auto_rotate = false
			_update_camera_position()

func _update_camera_position() -> void:
	# Calculate camera position based on orbit and distance
	var offset = Vector3()
	offset.x = sin(orbit_rotation.y) * cos(orbit_rotation.x) * current_distance
	offset.y = sin(orbit_rotation.x) * current_distance
	offset.z = cos(orbit_rotation.y) * cos(orbit_rotation.x) * current_distance
	
	position = target_position + offset
	look_at(target_position, Vector3.UP)
