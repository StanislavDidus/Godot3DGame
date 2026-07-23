extends RayCast3D

signal hit_item

func _process(delta: float) -> void:
	if is_colliding():
		if get_collider().is_in_group("items"):
			hit_item.emit()
