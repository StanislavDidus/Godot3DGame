extends StaticBody3D

signal clock_opened

@export var clock_name: String
@export var big_arrow_solution = 0
@export var small_arrow_solution = 0

var big_arrow_position = 0
var small_arrow_position = 0

var is_big_arrow_active = true # False then small arrow

var is_open = false
var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Pivot.rotation.z = deg_to_rad(big_arrow_position * -30.0 - 90.0)
	$Pivot2.rotation.z = deg_to_rad(small_arrow_position * -30.0 - 90.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	if Input.is_action_just_pressed("lock_number_left") or Input.is_action_just_pressed("lock_number_right"):
		is_big_arrow_active = !is_big_arrow_active
		
	if Input.is_action_just_pressed("lock_number_up"):
		if is_big_arrow_active:
			big_arrow_position = wrapi(big_arrow_position + 1, 0, 12)
		else:
			small_arrow_position = wrapi(small_arrow_position + 1, 0, 12)
	if Input.is_action_just_pressed("lock_number_down"):
		if is_big_arrow_active:
			big_arrow_position = wrapi(big_arrow_position - 1, 0, 12)
		else:
			small_arrow_position = wrapi(small_arrow_position - 1, 0, 12)
			
	$Pivot.rotation.z = deg_to_rad(big_arrow_position * -30.0 - 90.0)
	$Pivot2.rotation.z = deg_to_rad(small_arrow_position * -30.0 - 90.0)
	
	if not is_open:
		if big_arrow_solution == big_arrow_position:
			if small_arrow_position == small_arrow_solution:
				is_open = true
				is_active = false
				clock_opened.emit(clock_name)
	
func interact(player):
	player.clock = self
	player.set_state(player.PLAYER_STATE.CLOCK_PICK)
	
	var player_camera = player.get_node("Camera")
	
	var offset = Vector3(0, 1.3, 1.4)
	
	var target_camera_pos = to_global(offset)
	
	player_camera.global_position = target_camera_pos
	player_camera.look_at(get_node("LookAt").global_position)
