extends Node2D
class_name BasicEnemy

@export var data: EnemyData

@onready var sprite: Sprite2D = %Sprite2D
@onready var health_component: HealthComponent = %HealthComponent
@onready var movement_component: LinearMovementComponent = %LinearMovementComponent
@onready var attack_component: AttackComponent = %AttackComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent

func _ready() -> void:
	assert(data != null, "EnemyData não configurado no BasicEnemy!")

	sprite.texture = data.texture

	health_component.initialize(data.max_health)
	health_component.died.connect(_on_died)

	hurtbox_component.health_component = health_component
	hurtbox_component.faction = GameLayers.Faction.ENEMY

	movement_component.target_node = self
	movement_component.speed = data.move_speed
	movement_component.set_direction(LinearMovementComponent.LEFT)

	attack_component.configure(data.attack_power, data.attack_interval)
	attack_component.set_attack_range(data.attack_range)
	attack_component.faction = GameLayers.Faction.ENEMY
	attack_component.target_acquired.connect(movement_component.pause)
	attack_component.target_lost.connect(movement_component.resume)

	GameEvents.enemy_spawned.emit(data)

func _on_died() -> void:
	hurtbox_component.set_deferred("monitorable", false)
	hurtbox_component.set_deferred("monitoring", false)

	GameEvents.enemy_died.emit(data)
	queue_free()
