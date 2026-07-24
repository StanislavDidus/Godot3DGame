extends Node3D

signal lock_opened(name: String)

var is_active = true

@export var lock_name: String
@export var correct_combination: int
@export var text1:Label3D
@export var text2:Label3D
@export var text3:Label3D

var active_digit: int = 1
var value_1 = 0
var value_2 = 0
var value_3 = 0

var is_open = false

func init(code: int):
	correct_combination = code
	update_labels()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update():
	if Input.is_action_just_pressed("lock_number_up"):
		if active_digit == 1:
			value_1	+= 1
			if value_1 > 9: value_1 = 0
		if active_digit == 2:
			value_2	+= 1
			if value_2 > 9: value_2 = 0
		if active_digit == 3:
			value_3	+= 1
			if value_3 > 9: value_3 = 0
	if Input.is_action_just_pressed("lock_number_down"):
		if active_digit == 1:
			value_1	-= 1
			if value_1 < 0: value_1 = 9
		if active_digit == 2:
			value_2	-= 1
			if value_2 < 0: value_2 = 9
		if active_digit == 3:
			value_3	-= 1
			if value_3 < 0: value_3 = 9
		
	if Input.is_action_just_pressed("lock_number_right"):
		active_digit += 1
		if active_digit > 3: active_digit = 3
	if Input.is_action_just_pressed("lock_number_left"):
		active_digit -= 1
		if active_digit < 1: active_digit = 1
			
	update_labels()
	
	if !is_open:
		if value_1 == int(correct_combination / 100):
			if value_2 == int((correct_combination % 100) / 10):
				if value_3 == int(correct_combination % 10):
					is_open = true
					is_active = false
					lock_opened.emit(lock_name)
			
func update_labels():
	text1.text = str(value_1)
	text2.text = str(value_2)
	text3.text = str(value_3)
	
func interact(player):
	player.lock = self
	player.set_state(player.PLAYER_STATE.LOCK_PICK)
	
	var player_camera = player.get_node("Camera")
	
	var offset = Vector3(0, 0.5, 0.65)
	
	var target_camera_pos = to_global(offset)
	
	player_camera.global_position = target_camera_pos
	player_camera.look_at(global_position)
