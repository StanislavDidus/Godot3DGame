extends CharacterBody3D

@export_group("Movement")
@export var speed: float = 10.0
@export var mouse_sensitivity: float = 0.1
@export var crouch_offset: float = 0.3
@export var crouch_speed: float = 0.5

@export_group("Camera shaking")
@export var camera_shake_amplitude: float = 0.1
@export var camera_shake_speed: float = 2.0
@export var sidewalk_penalty = 0.5 # Percentage of how slower sidewalking is

@export_group("Item interactions")
@export var interaction_angle: float = 15.0
@export var interaction_distance: float = 2.5

@export_group("UI")
@export var interaction_label: Node
@export var inventory_ui: Node

@export_group("Inventory")
@export var inventory_size = 3
var items: Array

enum PLAYER_STATE
{
	IDLE,
	WALK,
	CROUCH
}

# Camera shake properties
var camera_origin_position: Vector3 = Vector3.ZERO
var timer: float = 0.0
var slow_timer: float = 0.0

# Camera movement
var twist_input: float = 0.0
var pitch_input: float = 0.0

var player_current_state: PLAYER_STATE = PLAYER_STATE.IDLE

var looking_at_item: bool = false

var crouch_tween: Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_origin_position = $Camera.position
	$Camera/RayCast3D.target_position.z = -interaction_distance
	inventory_ui.hide()

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
	
	if Input.is_action_just_pressed("open_inventory"):
		inventory_ui.show()
		$OpenInventoryTimer.start()
	
	interact_with_all_items()
	
	looking_at_item = false

func _physics_process(delta: float) -> void:
	timer += delta * camera_shake_speed
	slow_timer += delta * camera_shake_speed * 0.5
		
	on_update_state(player_current_state, delta)

func interact_with_all_items():
	var all_items = get_tree().get_nodes_in_group("items")
	
	var can_interact = false;
	for item in all_items:
		var items_vector = item.position - position
		var camera_vector = -$Camera.get_global_transform().basis.z
		
		if items_vector.dot(camera_vector) >= cos(deg_to_rad(interaction_angle)):
			if items_vector.length() <= interaction_distance:
				if looking_at_item:
					interaction_label.show()
					can_interact = true
					
					if Input.is_action_just_pressed("pickup_item"):
						items.append(item.data)
						item.queue_free()
						inventory_ui.update_inventory_icons(items)
					
				
	if !can_interact:
		interaction_label.hide()
		
func is_moving():
	if Input.is_action_pressed("move_left")	or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward")	or Input.is_action_pressed("move_back"):
		return true
	return false
	
func set_crouch(is_crouching: bool) -> void:
	if crouch_tween and crouch_tween.is_running():
		crouch_tween.kill()
		
	crouch_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	var target_y = camera_origin_position.y
	if is_crouching:
		target_y -= crouch_offset
		
	crouch_tween.tween_property($Camera, "position:y", target_y, crouch_speed)
	
# STATE MACHINE
func set_state(state):
	if player_current_state == state:
		pass
		
	on_exit_state(player_current_state)	
	
	player_current_state = state
	
	on_enter_state(player_current_state)
			
func on_enter_state(state):
	match state:
		PLAYER_STATE.IDLE:
			pass
		PLAYER_STATE.WALK:
			pass
		PLAYER_STATE.CROUCH:
			set_crouch(true)
	
func on_update_state(state, delta):
	match state:
		PLAYER_STATE.IDLE:
		
			if is_moving():
				set_state(PLAYER_STATE.WALK)
			
			if Input.is_action_pressed("crouch"):
				set_state(PLAYER_STATE.CROUCH)
				
			$Camera.position.y = camera_origin_position.y + camera_shake_amplitude * sin(slow_timer) * 0.5
				
		PLAYER_STATE.WALK:
		
			if !is_moving():
				set_state(PLAYER_STATE.IDLE)
				
			if Input.is_action_pressed("crouch"):
				set_state(PLAYER_STATE.CROUCH)
				
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
				
			velocity = target_velocity
			move_and_slide()
			
			$Camera.position.y = camera_origin_position.y + camera_shake_amplitude * sin(slow_timer)
			
		PLAYER_STATE.CROUCH:
			if !Input.is_action_pressed("crouch"):
				set_state(PLAYER_STATE.IDLE)
	
func on_exit_state(state):
	match state:
		PLAYER_STATE.IDLE:
			pass
		PLAYER_STATE.WALK:
			pass
		PLAYER_STATE.CROUCH:
			set_crouch(false)


func _on_ray_cast_3d_hit_item() -> void:
	looking_at_item = true


func _on_open_inventory_timer_timeout() -> void:
	inventory_ui.hide()
