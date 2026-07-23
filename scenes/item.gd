extends StaticBody3D

@export var data: item_data

@export var spawn_points: Array[Marker3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_spawn()
	
	if data.model != null:
		var model = data.model.instantiate()
		add_child(model)
		model.scale = data.model_scale
	else:
		$MeshInstance3D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func random_spawn():
	var rand = randi() % spawn_points.size()
	position = spawn_points[rand].global_position
