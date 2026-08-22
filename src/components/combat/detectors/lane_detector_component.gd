extends Node2D
class_name LaneDetectorComponent

signal target_detected
signal target_lost

@export var faction: GameLayers.Faction = GameLayers.Faction.TOWER
@export var ray_length: float = 480.0

var _raycasts: Array[RayCast2D] = []
var has_target: bool = false

func _ready() -> void:
	for child in get_children():
		if child is RayCast2D:
			_setup_raycast(child)
			_raycasts.append(child)

func _setup_raycast(ray: RayCast2D) -> void:
	match faction:
		GameLayers.Faction.TOWER:
			ray.collision_mask = GameLayers.LAYER_ENEMY_HURTBOX
		GameLayers.Faction.ENEMY:
			ray.collision_mask = GameLayers.LAYER_TOWER_HURTBOX
	ray.target_position = Vector2(ray_length, 0)
	ray.collide_with_areas = true
	ray.collide_with_bodies = false

func _physics_process(_delta: float) -> void:
	var current_detection := _check_any_ray_colliding()
	
	if current_detection and not has_target:
		has_target = true
		target_detected.emit()
	elif not current_detection and has_target:
		has_target = false
		target_lost.emit()

func _check_any_ray_colliding() -> bool:
	for ray in _raycasts:
		if ray.is_colliding():
			return true
	return false
