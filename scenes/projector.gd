extends StaticBody3D

signal projector_completed

@export var projector_name: String
@export var positions: Array[Marker3D]
@export var numbers: Array[Label3D]

@export var solution: int 

var red = Color(1,0,0)
var yellow = Color(1,0.8,0)
var blue = Color(0,0,1)

var is_active = true

var active_digit: int = 1

var value_1 = 0
var value_2 = 0
var value_3 = 0
var value_4 = 0
var value_5 = 0
var value_6 = 0

var blue_code: int = 147833
var red_code: int = 799412
var yellow_code: int = 652145

func get_digit(number: int, n: int) -> int:
	return (number / int(pow(10, n))) % 10

func check_number_solution(num):
	if numbers[num].modulate == red:
		if int(numbers[num].text) == get_digit(red_code, 5 - num):
			return true
	if numbers[num].modulate == yellow:
		if int(numbers[num].text) == get_digit(yellow_code, 5 - num):
			return true
	if numbers[num].modulate == blue:
		if int(numbers[num].text) == get_digit(blue_code, 5 - num):
			return true
	return false
	
func check_solution():
	var passes = true
	for i in range(0,6):
		if !check_number_solution(i):
			passes = false
			break
			
	if passes:
		is_active = false
		projector_completed.emit(projector_name)

func randomize():
	if !positions.is_empty():
		var pos = positions[randi() % positions.size()]
		
		position = pos.position
		position.y += $MeshInstance3D.get_aabb().size.y * 0.5
		rotation = pos.rotation
	
	for number in numbers:
		var col = randi() % 3
		if col == 0:
			number.modulate = red
		if col == 1:
			number.modulate = yellow
		if col == 2:
			number.modulate = blue
	
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
		if active_digit == 4:
			value_4	+= 1
			if value_4 > 9: value_4 = 0
		if active_digit == 5:
			value_5	+= 1
			if value_5 > 9: value_5 = 0
		if active_digit == 6:
			value_6	+= 1
			if value_6 > 9: value_6 = 0
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
		if active_digit == 4:
			value_4	-= 1
			if value_4 < 0: value_4 = 9
		if active_digit == 5:
			value_5	-= 1
			if value_5 < 0: value_5 = 9
		if active_digit == 6:
			value_6	-= 1
			if value_6 < 0: value_6 = 9
		
	if Input.is_action_just_pressed("lock_number_right"):
		active_digit += 1
		if active_digit > 6: active_digit = 6
	if Input.is_action_just_pressed("lock_number_left"):
		active_digit -= 1
		if active_digit < 1: active_digit = 1
		
	update_labels()
	check_solution()
		
		
func update_labels():
	numbers[0].text = str(value_1)
	numbers[1].text = str(value_2)
	numbers[2].text = str(value_3)
	numbers[3].text = str(value_4)
	numbers[4].text = str(value_5)
	numbers[5].text = str(value_6)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(player):
	player.projector = self
	player.set_state(player.PLAYER_STATE.PROJECTOR)
	
	var player_camera = player.get_node("Camera")
	
	var offset = Vector3(0, 0.6, 1.5)
	
	var target_camera_pos = to_global(offset)
	
	player_camera.global_position = target_camera_pos
	player_camera.look_at(get_node("LookAt").global_position)
