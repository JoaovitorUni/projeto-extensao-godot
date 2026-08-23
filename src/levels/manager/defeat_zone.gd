extends Area2D
class_name DefeatZone

signal enemy_crossed_line

func _ready() -> void:
	# Monitora apenas a Hurtbox dos inimigos (Layer 4)
	collision_layer = 0
	collision_mask = GameLayers.LAYER_ENEMY_HURTBOX
	
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		enemy_crossed_line.emit()
		GameEvents.base_breached.emit()
