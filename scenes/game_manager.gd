extends Node

@export var dialogue_window: CanvasLayer

@export var basement_lock: Node3D
@export var basement_wall_code: Label3D

@export var clock_note: Node3D

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
