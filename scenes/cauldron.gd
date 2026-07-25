extends StaticBody3D

var is_active = true

@export var dialogue_window: CanvasLayer
@export var post_trophy_message: String
@export var post_trophy_message2: String
@export var projector_lens: Node3D

@export var post_ring_message: String
@export var post_ring_message2: String

var hints: Array[String] = [
	"Hint 1", "Hint 2", "Hint 3"
]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projector_lens.hide()
	projector_lens.is_active = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(player):

	if player.active_item != null:
		if player.active_item.item_name == "trophy":
			player.active_item = null
			player.remove_item_in_hand()
			dialogue_window.show_message(post_trophy_message, 15.0)
			dialogue_window.show_message(post_trophy_message2, 15.0)
			projector_lens.show()
			projector_lens.is_active = true
			return
			
	if player.active_item != null:
		if player.active_item.item_name == "ring":
			player.active_item = null
			player.remove_item_in_hand()
			dialogue_window.show_message(post_ring_message, 15.0)
			dialogue_window.show_message(post_ring_message2, 15.0)
			#projector_lens.show()
			#projector_lens.is_active = true
			return

	if hints.is_empty(): return
	
	var rng = randi() % hints.size()
	dialogue_window.show_message(hints[rng], 7)
	
	is_active = false
	$Timer.start()


func _on_timer_timeout() -> void:
	is_active = true
