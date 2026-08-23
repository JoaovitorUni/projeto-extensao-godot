extends Area2D
class_name HitboxComponent

signal hit_applied(hurtbox: HurtboxComponent)

@export var damage: float = 10.0
@export var faction: GameLayers.Faction = GameLayers.Faction.TOWER

func _ready() -> void:
	match faction:
		GameLayers.Faction.TOWER:
			collision_layer = GameLayers.LAYER_TOWER_ATTACK
			collision_mask = GameLayers.LAYER_ENEMY_HURTBOX
		GameLayers.Faction.ENEMY:
			collision_layer = GameLayers.LAYER_ENEMY_ATTACK
			collision_mask = GameLayers.LAYER_TOWER_HURTBOX

	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.take_damage(damage)
		hit_applied.emit(area)
