extends TextureButton
class_name ShopSlot

@onready var cost_label: Label = $CostLabel

var tower_data: TowerData

func setup(data: TowerData) -> void:
	tower_data = data
	self.name = "ShopSlot_%s" % tower_data.name

	custom_minimum_size = Vector2(48, 32)

	_update_visuals()

func _ready() -> void:
	self.button_down.connect(_on_button_down)

func _update_visuals() -> void:
	if not tower_data: return
	cost_label.text = str(tower_data.cost) + " "
	if tower_data.slot_texture:
		texture_normal = tower_data.slot_texture

func _on_button_down() -> void:
	GameEvents.tower_purchase_requested.emit(tower_data)
