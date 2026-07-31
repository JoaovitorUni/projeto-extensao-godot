extends Area2D
class_name HurtboxComponent

@export var faction: LevelLayers.Faction = LevelLayers.Faction.TOWER
@export var health_component: HealthComponent

func _ready() -> void:
	match faction:
		LevelLayers.Faction.TOWER:
			collision_layer = LevelLayers.LAYER_TOWER_HURTBOX
			collision_mask = 0
		LevelLayers.Faction.ENEMY:
			collision_layer = LevelLayers.LAYER_ENEMY_HURTBOX
			collision_mask = 0

func take_damage(amount: float) -> void:
	if health_component and not health_component.is_dead:
		health_component.take_damage(amount)
