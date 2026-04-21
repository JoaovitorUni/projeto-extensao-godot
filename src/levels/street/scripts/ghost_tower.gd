extends Node2D
class_name GhostTower

var _tower_texture: Texture
var _sprite: Sprite2D

func _init(tower_data: TowerData) -> void:
	_tower_texture = tower_data.texture
	self.name = "GhostTower_%s" % tower_data.name
	
func _ready() -> void:
	_sprite = Sprite2D.new()
	_sprite.texture = _tower_texture
	_sprite.z_index = 10
	add_child(_sprite)

	process_mode = PROCESS_MODE_INHERIT
	global_position = get_global_mouse_position()
	GameEvents.tower_dropped.connect(_on_tower_dropped)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position()

func _on_tower_dropped() -> void:
	queue_free()
