extends Node2D
class_name GridComponent

@onready var grid_manager: GridManager = $grid
var _selected_tower_sprite: TowerData = null
var _tower_preview: GhostTower = null

func _ready() -> void:
	GameEvents.tower_grabbed.connect(func(tower_data: TowerData):
		_selected_tower_sprite = tower_data
	)
	GameEvents.tower_dropped.connect(func():
		_selected_tower_sprite = null
	)

func _input(event):
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT and _selected_tower_sprite:
		var mouse_pos: Vector2 = get_global_mouse_position()
		if grid_manager.can_place(mouse_pos):
			_show_tower_preview(mouse_pos)

func _show_tower_preview(mouse_pos: Vector2):
	if not _tower_preview:
		_tower_preview = GhostTower.new(_selected_tower_sprite)
		_tower_preview.modulate = Color(1, 1, 1, 0.5)
		add_child(_tower_preview)
	if _tower_preview:
		var cell_center_pos = grid_manager.get_cell_position_global(mouse_pos)
		_tower_preview.global_position = cell_center_pos
