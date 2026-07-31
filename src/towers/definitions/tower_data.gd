extends Resource
class_name TowerData

@export_category("Data")
@export var name: String = ""
@export var max_health: float = 0
@export var scene: PackedScene
@export_category("Economy")
@export var cost: int = 0
@export_category("Art")
@export var texture: Texture
@export var slot_texture: Texture2D
