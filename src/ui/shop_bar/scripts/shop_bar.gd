extends ScrollContainer
class_name ShopBar

const SHOP_SLOT_SCENE = preload("res://src/ui/shop_bar/shop_slot.tscn")

@export var selected_towers: Array[TowerData] = []

@onready var slots_container: VBoxContainer = $SlotsContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	render_shop()

func setup(towers: Array[TowerData]) -> void:
	selected_towers = towers
	if is_node_ready():
		render_shop()

func render_shop() -> void:
	for child in slots_container.get_children():
		child.queue_free()
		
	for tower_data in selected_towers:
		if not tower_data: continue
		
		var slot_instance = SHOP_SLOT_SCENE.instantiate() as ShopSlot
		slots_container.add_child(slot_instance)
		slot_instance.setup(tower_data)
