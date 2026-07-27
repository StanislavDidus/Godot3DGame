extends Node

@export var dialogue_window: CanvasLayer

@export var basement_lock: Node3D
@export var basement_wall_code: Label3D

@export var clock_note: Node3D
@export var clock_hint: Node3D

@export var ultraviolet_light: Node3D

@export var trophy: Node3D

@export var laptop: Node3D
var laptop_code: int
@export var laptop_lable: Label3D
@export var laptop_lock: Node3D

@export var ring: Node3D

@export var projector: Node3D
var is_laptop = false
var is_cable = false
var is_lens = false

@export var door: Node3D

@export var reset_timer_label: Label
var timer: float


var is_game_finished = false

#@export var items: Array[Node3D]

var basement_lock_code: int

func randomize_game():
	var all_items = get_tree().get_nodes_in_group("items")
	var all_item_pos = get_tree().get_nodes_in_group("item_markers")
	
	for i in range(all_items.size() - 1, -1, -1):
		if all_items[i].data.randomize_pos == false:
			all_items.remove_at(i)
	
	all_item_pos.shuffle()
	all_items.shuffle()
	var to = min(all_item_pos.size(), all_items.size())
	for i in range(0, to):
		all_items[i].global_position = all_item_pos[i].global_position
		
	for object in get_tree().get_nodes_in_group("objects"):
		object.randomize()
		
	laptop_code = randi() % 1000
	laptop_lable.text = str(laptop_code)
	laptop_lock.correct_combination = laptop_code

func init(): # Randomize function
	# Generate 3 digit code
	basement_lock_code = randi() % 1000
	basement_lock.init(basement_lock_code)
	basement_wall_code.text = str(basement_lock_code)
	
	#clock_note.init()
	
	randomize_game()
		
	ultraviolet_light.hide()
	
	trophy.hide()
	trophy.is_active = false
	trophy.freeze = true
	
	laptop.hide()
	laptop.is_active = false
	laptop.freeze = true
	
	laptop_lable.show()
	
	projector.is_active = false
	
	ring.is_active = false
	ring.freeze = true
	ring.hide()
	
	clock_hint.hide()

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	init()
	
	
func _process(delta: float) -> void:
		
	if $drone.playing == false:
		$drone.play()
		
	timer += delta
	
	var value = int($hard_reset_timer.wait_time - timer)
	if value < 0: value = 0
	reset_timer_label.text = str(value)

func _on_lock_lock_opened(name: Variant) -> void:
	match name:
		"Basement":
			#print("Basement lock opened.")
			dialogue_window.show_message("You opened the lock. What was it consealing from you?", 5.0)
			
			laptop.show()
			laptop.is_active = true
			laptop.freeze = false


func _on_put_item_item_put(name: String) -> void:
	match name:
		"Statue":
			print("Statue is whole again.")
		"Ultraviolet":
			print("Ultraviolet put")


func _on_put_ultraviolet_item_put(name: String) -> void:
	clock_hint.show()
	ultraviolet_light.show()


#func _on_clock_clock_opened() -> void:
		


func _on_statue_item_put(name: String) -> void:
	door.get_node("pivot").rotation.y = -130
	$door_open.play()

func _on_arcade_maze_completed(name: Variant) -> void:
	trophy.show()
	trophy.is_active = true
	trophy.freeze = false


func _on_drawer_screwdriver_item_put(name: String) -> void:
	#var tween = create_tween()
	#tween.tween_property(drawer.get_node("drawer"), "position", drawer.get_node("drawer").position + Vector3(0, 0, -0.7), 1.5)
	laptop.show()
	laptop.is_active = true
	laptop.freeze = false
	$drawer_open.play()


func _on_put_lens_item_put(name: String) -> void:
	is_lens = true
		
	print("put")
	if is_lens and is_laptop and is_cable:
		projector.is_active = true
		dialogue_window.show_message("Projector is supposed to be working now.", 3.5)

func _on_put_cable_item_put(name: String) -> void:
	is_cable = true
		
	print("put")
	if is_lens and is_laptop and is_cable:
		projector.is_active = true
		dialogue_window.show_message("Projector is supposed to be working now.", 3.5)

func _on_put_laptop_item_put(name: String) -> void:
	is_laptop = true
		
	print("put")
	if is_lens and is_laptop and is_cable:
		projector.is_active = true
		dialogue_window.show_message("Projector is supposed to be working now.", 3.5)


func _on_projector_projector_completed(name: String) -> void:
	ring.show()
	ring.is_active = true
	ring.freeze = false
	print("spawn ring")


func _on_clip_timer_timeout() -> void:
	$close_eyes_ui.get_node("AnimationPlayer").play("clip")
	
	$randomize_timer.start()


func _on_randomize_timer_timeout() -> void:
	randomize_game()


func _on_hard_reset_timer_timeout() -> void:
	if is_game_finished == false:
		$close_eyes_ui.get_node("AnimationPlayer").play("clip")
		
		$hard_reset_delay.start()


func _on_hard_reset_delay_timeout() -> void:
	if is_game_finished == false:
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_cauldron_finish_game() -> void:
	is_game_finished = true
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
