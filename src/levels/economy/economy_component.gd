extends Node
class_name EconomyComponent

@export var initial_currency: int = 0
@onready var economy_manager: EconomyManager = $economy

func _ready() -> void:
	set_initial_currency()
	GameEvents.tower_purchase_requested.connect(_on_tower_purchase_requested)
	GameEvents.tower_placed.connect(_on_tower_placed)

func set_initial_currency() -> void:
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
