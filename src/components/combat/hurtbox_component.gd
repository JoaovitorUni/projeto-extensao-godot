extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func take_damage(amount: float) -> void:
	if health_component and not health_component.is_dead:
		health_component.take_damage(amount)
