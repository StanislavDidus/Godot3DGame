extends StaticBody3D

@export var dialogue_window: CanvasLayer
@export var text: String 
@export var duration: float

var is_active = true

class clock_note_text:
	var text: String
	var big_arrow_pos = -1
	var small_arrow_pos = -1
	
	func _init(_text: String, _pos1: int, _pos2: int):
		text = _text
		big_arrow_pos = _pos1
		small_arrow_pos = _pos2

@export var clock_note = false
@export var clock: Node3D
var clock_texts: Array[clock_note_text] = [
	clock_note_text.new("Stands tall in the room. Has two hands. One short one long. Short is upset, long points east.", 3, 6),
	clock_note_text.new("Stands tall in the room. Has two hands. Query they ofter. Small is always right, long doesnt want to look at it.", 9, 3),
	clock_note_text.new("It was 6:35 when the clock stroke. It was hard not to hear it. Standing, watching, looking at us.", 6, 7),
]

func init():
	if clock_note:
		var rng = randi() % clock_texts.size()
		var clock_text = clock_texts[rng]
		text = clock_text.text
		clock.big_arrow_solution = clock_text.big_arrow_pos
		clock.small_arrow_solution = clock_text.small_arrow_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#init()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(player):
	dialogue_window.show_message(text, duration)

