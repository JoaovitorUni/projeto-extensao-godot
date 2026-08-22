extends Node2D
class_name PlaceholderTower

@export var data: TowerData

@onready var health_component: HealthComponent = %HealthComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var lane_detector_component: LaneDetectorComponent = %LaneDetectorComponent

var current_health: float

func _ready() -> void:
	assert(data != null, 'Não foi possível carregar o recurso. Verifique se a propriedade "Data" foi informada.')

	health_component.initialize(data.max_health)
	health_component.died.connect(_on_died)

	hurtbox_component.health_component = health_component
	hurtbox_component.faction = GameLayers.Faction.TOWER

	lane_detector_component.target_detected.connect(func():
		print("target_detected")
	)
	lane_detector_component.target_lost.connect(func():
		print("target_lost")
	)


func _on_died() -> void:
	hurtbox_component.set_deferred("monitorable", false)
	hurtbox_component.set_deferred("monitoring", false)
	queue_free()
