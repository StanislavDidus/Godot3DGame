extends CharacterBody3D

@export var speed: float = 10.0
@export var mouse_sensitivity: float = 0.1
@export var camera_shake_amplitude: float = 0.1
@export var camera_shake_speed: float = 2.0
@export var sidewalk_penalty = 0.5 # Percentage of how slower sidewalking is

# Camera shake properties
var camera_shake_current_amplitude: float = 0.0
var camera_origin_position: Vector3 = Vector3.ZERO
var timer: float = 0.0
var slow_timer: float = 0.0

# Camera movement
var twist_input: float = 0.0
var pitch_input: float = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_origin_position = $Camera.position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		twist_input -= event.screen_relative.x * mouse_sensitivity
		pitch_input -= event.screen_relative.y * mouse_sensitivity
		pitch_input = clamp(pitch_input, -85, 85)

func _process(delta: float) -> void:
	var current_q = basis.get_rotation_quaternion()
	var twist_q = Quaternion(Vector3.UP, deg_to_rad(twist_input))
	var pitch_q = Quaternion(Vector3.RIGHT, deg_to_rad(pitch_input))
	var smoothed_q = current_q.slerp(twist_q * pitch_q, delta * 10.0)
	basis = Basis(smoothed_q)

func _physics_process(delta: float) -> void:
	timer += delta * camera_shake_speed
	slow_timer += delta * camera_shake_speed * 0.5
	
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
		
	# Apply sidewalk penalty
	if direction.normalized().dot(-basis.z) <= 0.0:
		target_velocity *= sidewalk_penalty
	# If moving diagonally forward then we apply half of the penalty
	#elif target_velocity.dot(-basis.z) <= cos(deg_to_rad(50.0)):
		#target_velocity *= sidewalk_penalty * 0.5
		
	# Shake camera
	if direction != Vector3.ZERO:
		$Camera.position.y = camera_origin_position.y + camera_shake_amplitude * sin(timer)
	else:
	# Shake with lower speed
		$Camera.position.y = camera_origin_position.y + camera_shake_amplitude * sin(slow_timer) * 0.5
		
	velocity = target_velocity
	move_and_slide()
