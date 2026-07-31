extends Node2D
class_name GeneratorTower

@export var data: GeneratorTowerData

var current_health: float

func _ready() -> void:
	assert(data != null, 'Não foi possível carregar o recurso. Verifique se a propriedade "data" foi informada.')
	current_health = data.max_health
