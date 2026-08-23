extends Node2D
class_name ShooterTower

@export var data: ShooterTowerData

@onready var attack_cooldown_component: CooldownComponent = %AttackCooldownComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var lane_detector_component: LaneDetectorComponent = %LaneDetectorComponent
@onready var projectile_launcher_component: ProjectileLauncherComponent = %ProjectileLauncherComponent

var current_health: float

func _ready() -> void:
	assert(data != null, 'Não foi possível carregar o recurso. Verifique se a propriedade "Data" foi informada.')

	attack_cooldown_component.set_cooldown(data.shoot_cooldown)

	health_component.initialize(data.max_health)
	health_component.died.connect(_on_died)

	hurtbox_component.health_component = health_component
	hurtbox_component.faction = GameLayers.Faction.TOWER

	projectile_launcher_component.projectile_scene = data.projectile_scene

	lane_detector_component.target_detected.connect(func(): attack_cooldown_component.start(true))
	lane_detector_component.target_lost.connect(attack_cooldown_component.stop)
			
	attack_cooldown_component.cooldown_finished.connect(projectile_launcher_component.launch)

func _on_died() -> void:
	hurtbox_component.set_deferred("monitorable", false)
	hurtbox_component.set_deferred("monitoring", false)
	GameEvents.tower_died.emit(self)
	queue_free()
