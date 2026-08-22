extends Resource
class_name EnemyData

@export_category("Data")
@export var name: String = ""
@export var scene: PackedScene
@export var spawn_cost: int

@export_category("Stats")
@export var max_health: float = 100.0
@export var move_speed: float = 30.0
@export var attack_power: float = 10.0
@export var attack_interval: float = 1.0
@export var attack_range: float = 16.0

@export_category("Art")
@export var texture: Texture2D

## Instancia a cena associada, injeta a si mesmo como 'data' e aplica a posição global.
func instantiate_entity() -> Node:
	_validate_resource()
	var instance: Node = scene.instantiate()
	instance.data = self
	return instance

func _validate_resource() -> void:
	assert(scene != null, "O Resource '%s' tentou instanciar uma entidade sem PackedScene atribuída." % name)

func _to_string() -> String:
	return "EnemyData(%s)" % name
