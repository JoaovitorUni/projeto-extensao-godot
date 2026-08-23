extends Node2D

@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var movement_component: LinearMovementComponent = %LinearMovementComponent

func _ready() -> void:
	movement_component.target_node = self
	movement_component.set_direction(LinearMovementComponent.RIGHT)

	hitbox_component.hit_applied.connect(func(_enemy_hurtbox: HurtboxComponent): queue_free())
