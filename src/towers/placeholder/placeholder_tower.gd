extends Node2D
class_name PlaceholderTower

@export var data: TowerData

var current_health: float

func _ready() -> void:
	assert(data != null, 'Não foi possível carregar o recurso. Verifique se a propriedade "Data" foi informada.')
	current_health = data.max_health
