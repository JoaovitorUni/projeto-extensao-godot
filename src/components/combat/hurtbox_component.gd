extends Area2D
class_name HurtboxComponent

@export var faction: GameLayers.Faction = GameLayers.Faction.TOWER
@export var health_component: HealthComponent

func _ready() -> void:
	match faction:
		GameLayers.Faction.TOWER:
			collision_layer = GameLayers.LAYER_TOWER_HURTBOX
			collision_mask = 0
		GameLayers.Faction.ENEMY:
			collision_layer = GameLayers.LAYER_ENEMY_HURTBOX
			collision_mask = 0

func take_damage(amount: float) -> void:
	if health_component and not health_component.is_dead:
		health_component.take_damage(amount)
