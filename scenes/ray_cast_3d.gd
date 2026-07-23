extends RayCast3D

signal hit_item

func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider != null:
			if collider.is_in_group("items") or collider.is_in_group("put_items"):
				hit_item.emit()
