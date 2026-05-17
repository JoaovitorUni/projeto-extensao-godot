extends Node
class_name CurrencySpawnerComponent

@export var currency_scene: PackedScene
@export var min_spawn_interval: float = 9.0
@export var max_spawn_interval: float = 10.0
@export var first_spawn_delay: float = 7.0
@export var debug: bool = false

var _timer: Timer
var _grid_component: GridComponent
var _currency_size: Vector2
var _target_area: Rect2

func _ready() -> void:
	assert(currency_scene != null, 'Não foi possível encontrar a cena. Verifique se a propriedade "currency_scene" foi informada.')

	_grid_component = get_parent() as GridComponent
	assert(_grid_component != null, 'CurrencySpawnerComponent deve ser inserido como filho de um GridComponent.')

	_currency_size = _get_currency_scene_size()
	assert(_currency_size != Vector2.ZERO, "Não foi possível identificar o tamanho da currency. Verifique a estrutura interna da cena.")

	_target_area = await _get_adjusted_target_area()

	_create_spawn_timer()
	_timer.timeout.connect(_on_timer_timeout)

	if debug:
		_show_debug_target_area()

func _create_spawn_timer() -> void:
	_timer = Timer.new()
	_timer.name = "SpawnTimer"
	_timer.one_shot = true
	_timer.wait_time = first_spawn_delay
	add_child(_timer)
	_timer.start()

func _on_timer_timeout() -> void:
	_spawn_currency_in_grid_bounds()
	_timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	_timer.start()

func _get_currency_scene_size() -> Vector2:
	var currency = currency_scene.instantiate()
	var sprite = currency.get_node_or_null("Sprite2D") as Sprite2D
	currency.queue_free()

	var currency_size = Vector2.ZERO
	if sprite and sprite.texture:
		currency_size = sprite.texture.get_size() * sprite.scale
	return currency_size

func _get_adjusted_target_area() -> Rect2:
	await get_tree().process_frame
	var global_bounds = _grid_component.get_global_bounds()

	var margin_x = - (_currency_size.x / 2.0)
	var margin_y = - (_currency_size.y / 2.0)

	return global_bounds.grow_individual(margin_x, margin_y, margin_x, margin_y)

func _spawn_currency_in_grid_bounds() -> void:
	if _target_area.size == Vector2.ZERO:
		return

	var currency_instance = currency_scene.instantiate() as Currency
	if not currency_instance:
		return

	var random_global_x = randf_range(_target_area.position.x, _target_area.end.x)
	var random_global_y = randf_range(_target_area.position.y, _target_area.end.y)

	var spawn_global_pos = Vector2(random_global_x, 0 - (_currency_size.y / 2))

	var target_global_y = random_global_y

	get_tree().current_scene.add_child(currency_instance)
	currency_instance.setup(spawn_global_pos, target_global_y)

func _show_debug_target_area() -> void:
	if _target_area.size == Vector2.ZERO:
		return
	
	var debug_rect = ColorRect.new()
	debug_rect.name = "CurrencySpawnTargetAreaDebug"
	debug_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	debug_rect.color = Color8(0, 153, 179, 42)

	debug_rect.global_position = _target_area.position
	debug_rect.size = _target_area.size
	
	get_tree().current_scene.add_child(debug_rect)
