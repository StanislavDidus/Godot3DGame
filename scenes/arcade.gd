extends StaticBody3D

signal maze_completed(name)

@export var maze_name: String
@export var positions: Array[Marker3D]

@export var maze: Array[int] = [
	2, 1, 0, 0, 0,
	0, 1, 0, 1, 0,
	0, 1, 0, 1, 0,
	0, 1, 0, 1, 3,
	0, 0, 0, 1, 0,
]

@export var figure: MeshInstance3D
@export var start_pos = Vector3(-0.25, 0.6, 0.5)
var figure_position_x = 0
var figure_position_y = 0

var is_active = true

func randomize():
	if positions.is_empty(): return
	var pos = positions[randi() % positions.size()]
	
	position = pos.position
	position.y += $MeshInstance3D.get_aabb().size.y * 0.5
	rotation = pos.rotation
	
func update():
	if Input.is_action_just_pressed("lock_number_left"):
		figure_position_x = clamp(figure_position_x - 1, 0, 4)
	if Input.is_action_just_pressed("lock_number_right"):
		figure_position_x = clamp(figure_position_x + 1, 0, 4)
	if Input.is_action_just_pressed("lock_number_down"):
		figure_position_y = clamp(figure_position_y + 1, 0, 4)
	if Input.is_action_just_pressed("lock_number_up"):
		figure_position_y = clamp(figure_position_y - 1, 0, 4)
		
	var index = figure_position_y * 5 + figure_position_x
	if maze[index] == 1:
		figure_position_y = 0
		figure_position_x = 0
	if maze[index] == 3:
		is_active = false
		maze_completed.emit(maze_name)
		
	$Screen/Figure.position = start_pos + Vector3(figure_position_x * 0.11, figure_position_y * -0.11, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(player):
	player.maze = self
	player.set_state(player.PLAYER_STATE.MAZE)
	
	var player_camera = player.get_node("Camera")
	
	var offset = Vector3(0, 0.5, 1.4)
	
	var target_camera_pos = to_global(offset)
	
	player_camera.global_position = target_camera_pos
	player_camera.look_at(get_node("LookAt").global_position)
