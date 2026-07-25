class_name put_item_base extends Node3D

signal item_put(name: String)

@export var spawn_item = true
@export var use_item = true
@export var put_item_name: String
@export var item_position: Node3D
@export var item_name: String

var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func interact(player):
	if player.active_item != null:
		var equipped_item = player.active_item
		if item_name == equipped_item.item_name:
		
			if use_item:	
				player.active_item = null
				player.remove_item_in_hand()
				
			# Spawn Object in the marker position
			if spawn_item:
				if equipped_item.model != null:
					var model_instance = equipped_item.model.instantiate()
					model_instance.scale = equipped_item.model_scale
					get_node("Marker").add_child(model_instance)
				
			is_active = false
			item_put.emit(put_item_name)
		
