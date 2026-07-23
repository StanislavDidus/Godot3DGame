extends StaticBody3D

@export var data: item_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if data.model_mesh != null:
		$MeshInstance3D.mesh = data.model_mesh
	$MeshInstance3D.scale = data.model_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
