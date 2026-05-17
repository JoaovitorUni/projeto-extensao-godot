extends Node2D
class_name GridComponent

@onready var grid_manager: GridManager = $grid
var _selected_tower_data: TowerData = null
var _tower_preview: GhostTower = null

func _ready() -> void:
	GameEvents.tower_grabbed.connect(func(tower_data: TowerData):
		_selected_tower_data = tower_data
	)
	GameEvents.tower_dropped.connect(func():
		_try_place_tower()
		_selected_tower_data = null
	)

func _input(event):
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT and _selected_tower_data:
		var mouse_pos: Vector2 = get_global_mouse_position()
		if grid_manager.can_place(mouse_pos):
			_show_tower_preview(mouse_pos)

func get_global_bounds() -> Rect2:
	if not grid_manager:
		return Rect2()
		
	var used_rect: Rect2i = grid_manager.get_used_rect()
	var tile_size: Vector2 = Vector2(grid_manager.tile_set.tile_size)
	
	var local_pos: Vector2 = Vector2(used_rect.position) * tile_size
	var local_size: Vector2 = Vector2(used_rect.size) * tile_size
	
	return Rect2(to_global(local_pos), local_size)

func _try_place_tower() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	if grid_manager.can_place(mouse_pos):
		var cell = grid_manager.get_grid_cell(mouse_pos)
		var cell_center_pos = grid_manager.get_cell_position(mouse_pos)

		var tower = _selected_tower_data.scene.instantiate()
		tower.name = "%s_%s" % [tower.name, cell]
		tower.data = _selected_tower_data
		tower.global_position = cell_center_pos
		add_child(tower)
		
		grid_manager.place(mouse_pos, tower)
		GameEvents.tower_placed.emit(_selected_tower_data)

func _show_tower_preview(mouse_pos: Vector2):
	if not _tower_preview:
		_tower_preview = GhostTower.new(_selected_tower_data)
		_tower_preview.modulate = Color(1, 1, 1, 0.5)
		add_child(_tower_preview)
	if _tower_preview:
		var cell_center_pos = grid_manager.get_cell_position_global(mouse_pos)
		_tower_preview.global_position = cell_center_pos
