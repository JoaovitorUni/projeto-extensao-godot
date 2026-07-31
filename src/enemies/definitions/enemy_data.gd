extends Resource
class_name EnemyData

@export_category("Data")
@export var name: String = ""
@export var scene: PackedScene

@export_category("Stats")
@export var max_health: float = 100.0
@export var move_speed: float = 30.0
@export var attack_power: float = 10.0
@export var attack_interval: float = 1.0
@export var attack_range: float = 16.0

@export_category("Art")
@export var texture: Texture2D
