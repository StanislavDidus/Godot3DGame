extends StaticBody3D

var is_active = true

@export var dialogue_window: CanvasLayer

var hints: Array[String] = [
	"Hint 1", "Hint 2", "Hint 3"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(player):
	if hints.is_empty(): return
	
	var rng = randi() % hints.size()
	dialogue_window.show_message(hints[rng], 7)
	
	is_active = false
	$Timer.start()


func _on_timer_timeout() -> void:
	is_active = true
