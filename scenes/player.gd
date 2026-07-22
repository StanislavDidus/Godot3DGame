extends CharacterBody3D

@export var speed: float = 10

@export var mouse_sensitivity: float = 0.1

var twist_input: float = 0.0
var pitch_input: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		twist_input -= event.screen_relative.x * mouse_sensitivity
		pitch_input -= event.screen_relative.y * mouse_sensitivity
		pitch_input = clamp(pitch_input, -85, 85)


func _process(delta: float) -> void:
	var current_q = basis.get_rotation_quaternion()
	var twist_q = Quaternion(Vector3.UP, deg_to_rad(twist_input))
	var pitch_q = Quaternion(Vector3.RIGHT, deg_to_rad(pitch_input))
	var smoothed_q = current_q.slerp(twist_q * pitch_q, delta * 20.0)
	basis = Basis(smoothed_q)

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO		
	var target_velocity = Vector3.ZERO
	
	var basis = $Camera.get_global_transform().basis
	
	if Input.is_action_pressed("move_left"):
		direction -= basis.x
	if Input.is_action_pressed("move_right"):
		direction += basis.x
	if Input.is_action_pressed("move_forward"):
		direction -= basis.z
	if Input.is_action_pressed("move_back"):
		direction += basis.z
		
	if direction != Vector3.ZERO:
		direction.y = 0
		target_velocity = direction.normalized() * speed
		
	velocity = target_velocity
	move_and_slide()
