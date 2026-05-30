extends Node2D

@export_category("Level Config")
@export var shop_bar_scene: PackedScene # TODO: Remover isso ao componentizar.
@export var level_towers: Array[TowerData] = []

@export_category("Debug")
@export var debug_tower_events: bool = false
@export var debug_economy_events: bool = false

var _grabbed_tower: bool = false

func _ready() -> void:
	LevelLayers.setup($Game, $UI, $Overlay)
	GameEvents.tower_purchase_approved.connect(_on_tower_purchase_approved)
	GameEvents.tower_grabbed.connect(_on_tower_grabbed)
	if debug_tower_events:
		_set_debug_tower_events_handlers()
	if debug_economy_events:
		_set_debug_economy_events_handlers()
	_build_level_ui()

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
	LevelLayers.add_child_overlay(ghost_tower)

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

# TODO: Componentizar construção da UI.
func _build_level_ui() -> void:
	if not shop_bar_scene:
		print("UI Build: Não foi possível achar a cena `shop_bar`.")
		return

	var shop_instance = shop_bar_scene.instantiate() as ShopBar
	shop_instance.position = Vector2(16, 30)
	LevelLayers.add_child_overlay(shop_instance)
	shop_instance.setup(level_towers)
