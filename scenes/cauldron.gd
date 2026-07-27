extends StaticBody3D

var is_active = true

@export var dialogue_window: CanvasLayer
@export var post_trophy_message: String
@export var post_trophy_message2: String
@export var projector_lens: Node3D

@export var post_ring_message: String
@export var post_ring_message2: String
@export var post_ring_message3: String

var hints: Array[String] = [
	"I think you could use the ultraviolet torch to light the area.", "It seems like the statue lacks the head.", "You need to turn on the projector by finding its 3 peaces.", "The code to the lock is somewhere in the room"
]

signal finish_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projector_lens.hide()
	projector_lens.is_active = false
	
	dialogue_window.show_message("Hi stranger. Yes I am a Cauldron talking to you. Don't worry if you dont understand where you are. I would just like you to bring me an item. Find a trophy in the room and bring it to me.", 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $bubbling.playing == false:
		$bubbling.play()
		
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
			dialogue_window.show_message(post_ring_message3, 15.0)
			
			$finish_timer.start()
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


func _on_finish_timer_timeout() -> void:
	finish_game.emit()
