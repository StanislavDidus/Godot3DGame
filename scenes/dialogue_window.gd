extends CanvasLayer

class message:
	var text: String
	var duration: float = 0.0
	
	func _init(_text: String, _duration: float):
		text = _text
		duration = _duration

@export var speed: float = 0.05 # seconds per letter

var timer: float = 0.0

var messages: Array[message]

func show_message(text: String, duration: float):
	messages.append(message.new(text, duration))	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if messages.is_empty():
		return
		
	timer += delta
		
	var active_message = messages[0]
	
	$ColorRect.show()
	$Label.text = active_message.text
	$Label.visible_characters = timer / speed
	
	if timer >= active_message.duration:
		timer = 0.0
		$Label.text = ""
		$ColorRect.hide()
		messages.remove_at(0)
	
	
