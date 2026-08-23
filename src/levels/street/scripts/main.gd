extends Node2D

# TODO: Futuramente o objetivo instanciar um Level programaticamente passando as configs que estarão na UI.
# Fluxo: seleciona Level 1 (Button), botão cria level passando as configurações.
@export_category("Level Config")
@export var level_towers: Array[TowerData] = []
# TODO: Remover isso ao componentizar.
@export var shop_bar_scene: PackedScene
@export var currency_counter_scene: PackedScene

@export_category("Debug")
@export var debug_tower_events: bool = false
@export var debug_economy_events: bool = false
@export var debug_wave_events: bool = false

@onready var wave_manager = $WaveManager

var _grabbed_tower: bool = false

func _ready() -> void:
	GameLayers.setup($Game, $UI, $Overlay, %TowersContainer, %EnemiesContainer, %ProjectilesContainer)
	GameEvents.tower_purchase_approved.connect(_on_tower_purchase_approved)
	GameEvents.tower_grabbed.connect(_on_tower_grabbed)
	if debug_tower_events:
		_set_debug_tower_events_handlers()
	if debug_economy_events:
		_set_debug_economy_events_handlers()
	if debug_wave_events:
		_set_debug_wave_events_handlers()
	_build_level_ui()

	wave_manager.start_level()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed() and _grabbed_tower:
		_on_tower_dropped()

func _on_tower_purchase_approved(tower_data: TowerData) -> void:
	GameEvents.tower_grabbed.emit(tower_data)

func _on_tower_grabbed(tower_data: TowerData) -> void:
	_grabbed_tower = true
	_create_ghost_tower(tower_data)

func _create_ghost_tower(tower_data: TowerData):
	var ghost_tower = GhostTower.new(tower_data)
	GameLayers.add_child_overlay(ghost_tower)

func _on_tower_dropped() -> void:
	_grabbed_tower = false
	GameEvents.tower_dropped.emit()

func _set_debug_tower_events_handlers() -> void:
	GameEvents.tower_grabbed.connect(func(tower_data: TowerData):
		print("Evento: tower_grabbed. TowerData: %s." % tower_data.name)
	)
	GameEvents.tower_placed.connect(func(tower_data: TowerData):
		print("Evento: tower_placed. TowerData: %s." % tower_data.name)
	)
	GameEvents.tower_dropped.connect(func(): print("Evento: tower_dropped."))

func _set_debug_economy_events_handlers() -> void:
	GameEvents.tower_purchase_requested.connect(func(tower_data: TowerData):
		print("Evento: tower_purchase_requested. TowerData: %s." % tower_data.name)
	)
	GameEvents.tower_purchase_approved.connect(func(tower_data: TowerData):
		print("Evento: tower_purchase_approved. TowerData: %s." % tower_data.name)
	)
	GameEvents.tower_purchase_denied.connect(func(tower_data: TowerData):
		print("Evento: tower_purchase_denied. TowerData: %s." % tower_data.name)
	)
	GameEvents.currency_collected.connect(func(value: int):
		print("Evento: currency_collected. Value: %d." % value)
	)
	GameEvents.currency_changed.connect(func(new_currency: int):
		print("Evento: currency_changed. New Currency: %d." % new_currency)
	)

func _set_debug_wave_events_handlers() -> void:
	GameEvents.wave_started.connect(func(wave_index: int, is_flag_wave: bool):
		print("Evento: wave_started. Wave Index: %s, Flag Wave: %s." % [wave_index, is_flag_wave])
	)
	GameEvents.wave_completed.connect(func(wave_index: int):
		print("Evento: wave_completed. Wave Index: %s." % wave_index)
	)
	GameEvents.all_waves_completed.connect(func(tower_data: TowerData):
		print("Evento: all_waves_completed. TowerData: %s." % tower_data.name)
	)

# TODO: Componentizar construção da UI.
func _build_level_ui() -> void:
	if not shop_bar_scene or not currency_counter_scene:
		print("UI Build: Não foi possível achar todas as cenas necessárias para montar a UI.")
		return

	var shop_instance = shop_bar_scene.instantiate() as ShopBar
	shop_instance.position = Vector2(16, 30)
	GameLayers.add_child_ui(shop_instance)
	shop_instance.setup(level_towers)

	var currency_counter_instance = currency_counter_scene.instantiate() as CurrencyCounter
	currency_counter_instance.position = Vector2(16, 4)
	GameLayers.add_child_ui(currency_counter_instance)
