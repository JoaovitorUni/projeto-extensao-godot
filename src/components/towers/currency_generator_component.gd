extends Node2D
class_name CurrencyGeneratorComponent

@export var data: GeneratorTowerData
@export var currency_scene: PackedScene

var _timer: Timer
@onready var _spawn_area_node: Area2D = $GeneratorSpawnArea
@onready var _collision_shape_node: CollisionShape2D = $GeneratorSpawnArea/CollisionShape2D

func _ready() -> void:
	if not data and get_parent() and "data" in get_parent():
		data = get_parent().get("data") as GeneratorTowerData
	assert(data != null, "Não foi possível carregar o recurso. Verifique se a propriedade 'data' (GeneratorTowerData) foi informada.")
	assert(currency_scene != null, "Não foi possível carregar o recurso. Verifique se a propriedade 'currency_scene' foi informada.")

	_setup_timer()

func generate_currency() -> void:
	var value := data.currency_value
	GameEvents.currency_generated.emit(value)
	_spawn_collectable(value)

func _setup_timer() -> void:
	_timer = Timer.new()
	_timer.name = "GeneratorTimer"
	_timer.wait_time = data.generation_interval
	_timer.autostart = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)

func _on_timer_timeout() -> void:
	generate_currency()

func _spawn_collectable(value: int) -> void:
	var currency_instance := currency_scene.instantiate() as Currency
	if get_parent():
		currency_instance.name = "Currency_%s" % get_parent().name

	LevelLayers.add_child_overlay(currency_instance)

	var local_spawn_pos := _get_random_point_in_spawn_area()
	var target_global_pos := _spawn_area_node.to_global(local_spawn_pos)

	currency_instance.global_position = global_position

	currency_instance.set("fall_speed", 0.0)
	currency_instance.setup(global_position, target_global_pos.y)

	var tween := create_tween().set_parallel(true)
	tween.tween_property(currency_instance, "global_position:x", target_global_pos.x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	var y_tween := create_tween().set_trans(Tween.TRANS_QUAD)
	var peak_y := minf(global_position.y, target_global_pos.y) - 20.0
	y_tween.tween_property(currency_instance, "global_position:y", peak_y, 0.25).set_ease(Tween.EASE_OUT)
	y_tween.tween_property(currency_instance, "global_position:y", target_global_pos.y, 0.25).set_ease(Tween.EASE_IN)

	var area := currency_instance.get_node_or_null("Area2D") as Area2D
	if area:
		area.set("value", value)

func _get_random_point_in_spawn_area() -> Vector2:
	var shape := _collision_shape_node.shape
	var center := _collision_shape_node.position

	if shape is CircleShape2D:
		var circle := shape as CircleShape2D
		var angle := randf() * TAU
		var r := sqrt(randf()) * circle.radius
		return center + Vector2(cos(angle), sin(angle)) * r

	var rect := shape.get_rect()
	var rx := randf_range(center.x + rect.position.x, center.x + rect.end.x)
	var ry := randf_range(center.y + rect.position.y, center.y + rect.end.y)
	return Vector2(rx, ry)
