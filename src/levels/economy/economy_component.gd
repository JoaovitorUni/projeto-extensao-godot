extends Node
class_name EconomyComponent

@export var initial_currency: int = 0
@onready var economy_manager: EconomyManager = $economy

func _ready() -> void:
	_set_initial_currency()
	GameEvents.tower_purchase_requested.connect(_on_tower_purchase_requested)
	GameEvents.tower_placed.connect(_on_tower_placed)
	GameEvents.currency_collected.connect(_on_currency_collected)

func get_current_currency() -> int:
	return economy_manager.current_currency

func _set_initial_currency() -> void:
	economy_manager.current_currency = initial_currency

func _on_tower_purchase_requested(tower_data: TowerData) -> void:
	if economy_manager.has_enough_currency(tower_data.cost):
		GameEvents.tower_purchase_approved.emit(tower_data)
	else:
		GameEvents.tower_purchase_denied.emit(tower_data)

func _on_tower_placed(tower_data: TowerData) -> void:
	if economy_manager.has_enough_currency(tower_data.cost):
		economy_manager.subtract_currency(tower_data.cost)
		GameEvents.tower_purchased.emit()
		GameEvents.currency_changed.emit(economy_manager.current_currency)

func _on_currency_collected(value: int) -> void:
	economy_manager.add_currency(value)
	GameEvents.currency_changed.emit(economy_manager.current_currency)
