class_name item_data extends Resource

@export var item_name: String = ""
@export var icon_image: Texture2D
@export var model: PackedScene
@export var model_scale: Vector3 = Vector3(1, 1, 1)
#@export var positions: Array[Marker3D]
var item_scene: Node
@export var randomize_pos: bool = true
