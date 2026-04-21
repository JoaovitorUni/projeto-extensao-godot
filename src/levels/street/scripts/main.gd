extends Node2D

@export var debug_events: bool = false
var _grabbed_tower: bool = false

func _ready() -> void:
	GameEvents.tower_grabbed.connect(func(_tower_data): _grabbed_tower = true)
	if debug_events:
		_set_debug_events_handlers()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed() and _grabbed_tower:
		_grabbed_tower = false
		GameEvents.tower_dropped.emit()

func _set_debug_events_handlers() -> void:
	GameEvents.tower_grabbed.connect(func(tower_data: TowerData):
		print("Evento: tower_grabbed. TowerData: %s." % tower_data.name)
	)
	GameEvents.tower_placed.connect(func(tower_data: TowerData):
		print("Evento: tower_placed. TowerData: %s." % tower_data.name)
	)
	GameEvents.tower_dropped.connect(func(): print("Evento: tower_dropped."))
