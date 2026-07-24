extends StaticBody3D

@export var data: item_data

@export var spawn_points: Array[Marker3D]

var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_spawn()
	
	if data.model != null:
		var model = data.model.instantiate()
		add_child(model)
		model.scale = data.model_scale
	else:
		$MeshInstance3D.hide()

func random_spawn():
	var rand = randi() % spawn_points.size()
	position = spawn_points[rand].global_position

func interact(player):
	if player.items.size() < player.inventory_size:
		player.items.append(data)
		player.inventory_ui.update_inventory_icons(player.items)
		queue_free()		
