extends Node2D

# TODO: Futuramente o objetivo instanciar um Level programaticamente passando as configs que estarão na UI.
# Fluxo: seleciona Level 1 (Button), botão cria level passando as configurações.
@export_category("Level Config")
@export var level_towers: Array[TowerData] = []
# TODO: Remover isso ao componentizar.
@export var shop_bar_scene: PackedScene
@export var currency_counter_scene: PackedScene

@onready var wave_manager = $WaveManager

var _grabbed_tower: bool = false
var _wave_start_timer: Timer

func _ready() -> void:
	GameLayers.setup($Game, $UI, $Overlay, %TowersContainer, %EnemiesContainer, %ProjectilesContainer)
	GameEvents.tower_purchase_approved.connect(_on_tower_purchase_approved)
	GameEvents.tower_grabbed.connect(_on_tower_grabbed)
	_build_level_ui()

	_wave_start_timer = Timer.new()
	_wave_start_timer.autostart = true
	_wave_start_timer.one_shot = true
	_wave_start_timer.wait_time = 20
	_wave_start_timer.timeout.connect(func(): wave_manager.start_level())
	add_child(_wave_start_timer)
	

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
