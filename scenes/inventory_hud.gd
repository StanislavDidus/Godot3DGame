extends CanvasLayer

@export var slots: Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_inventory_icons(inventory: Array):
	for i in range(0, slots.size()):
		slots[i].get_node("TextureRect").texture = null

	var current_slot = 0
	for item in inventory:
		slots[current_slot].get_node("TextureRect").texture = item.icon_image
		current_slot += 1
		
		if current_slot >= slots.size():
			return