extends Button

@export var tower_data: TowerData

func _ready() -> void:
	self.button_down.connect(_on_button_down)

func _on_button_down() -> void:
	GameEvents.tower_purchase_requested.emit(tower_data)
