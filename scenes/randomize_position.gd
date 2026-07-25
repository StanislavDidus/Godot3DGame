extends Node3D

@export var main_object: StaticBody3D
@export var positions: Array[Marker3D]

func randomize():
	if positions.is_empty(): return
	var pos = positions[randi() % positions.size()]
	
	position = pos.position
	position.y += $MeshInstance3D.get_aabb().size.y * 0.5
	rotation = pos.rotation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
