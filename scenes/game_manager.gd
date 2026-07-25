extends Node

@export var dialogue_window: CanvasLayer

@export var basement_lock: Node3D
@export var basement_wall_code: Label3D

@export var clock_note: Node3D
@export var clock_hint: Node3D

@export var ultraviolet_light: Node3D

@export var trophy: Node3D

@export var drawer: Node3D

@export var laptop: Node3D

@export var ring: Node3D

@export var projector: Node3D
var is_laptop = false
var is_cable = false
var is_lens = false

#@export var items: Array[Node3D]

var basement_lock_code: int

func init(): # Randomize function
	# Generate 3 digit code
	basement_lock_code = randi() % 1000
	basement_lock.init(basement_lock_code)
	basement_wall_code.text = str(basement_lock_code)
	
	clock_note.init()
	
	for item in get_tree().get_nodes_in_group("items"):
		item.randomize()
		
	for object in get_tree().get_nodes_in_group("objects"):
		object.randomize()
		
	ultraviolet_light.hide()
	
	trophy.hide()
	trophy.is_active = false
	
	laptop.hide()
	laptop.is_active = false
	
	projector.is_active = false
	
	ring.is_active = false
	ring.hide()
	
	clock_hint.hide()
	

func _ready() -> void:
	init()
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("randomize"):
		init()

func _on_lock_lock_opened(name: Variant) -> void:
	match name:
		"Basement":
			print("Basement lock opened.")
			dialogue_window.show_message("You opened the lock. What was it consealing from you?", 5.0)


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
	print("Head is on a statue")


func _on_arcade_maze_completed(name: Variant) -> void:
	trophy.show()
	trophy.is_active = true


func _on_drawer_screwdriver_item_put(name: String) -> void:
	#var tween = create_tween()
	#tween.tween_property(drawer.get_node("drawer"), "position", drawer.get_node("drawer").position + Vector3(0, 0, -0.7), 1.5)
	laptop.show()
	laptop.is_active = true


func _on_put_lens_item_put(name: String) -> void:
	is_lens = true
		
	print("put")
	if is_lens and is_laptop and is_cable:
		projector.is_active = true

func _on_put_cable_item_put(name: String) -> void:
	is_cable = true
		
	print("put")
	if is_lens and is_laptop and is_cable:
		projector.is_active = true

func _on_put_laptop_item_put(name: String) -> void:
	is_laptop = true
		
	print("put")
	if is_lens and is_laptop and is_cable:
		projector.is_active = true


func _on_projector_projector_completed() -> void:
	ring.show()
	ring.is_active = true
