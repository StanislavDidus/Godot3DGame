extends RigidBody3D

@export var data: item_data

@export var spawn_points: Array[Marker3D]

var is_active = true

func randomize():
	random_spawn()	

func init():
	if data:
		if data.model != null:
			var model = data.model.instantiate()
			add_child(model)
			model.scale = data.model_scale
		else:
			$MeshInstance3D.hide()
		
	data.item_scene = duplicate()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()

func random_spawn():
	var rand = randi() % spawn_points.size()
	position = spawn_points[rand].global_position

func interact(player):
	if player.active_item == null:
		player.active_item = data
		queue_free()		
		
		var item = data.model.instantiate()
		item.scale = data.model_scale
		player.get_node("Camera/HandPivot").add_child(item)
		
