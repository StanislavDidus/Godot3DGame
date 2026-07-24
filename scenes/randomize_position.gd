extends Node3D

@export var positions: Array[Marker3D]

func randomize():
	for pos in positions:
		position = pos.position
		rotation = pos.rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
