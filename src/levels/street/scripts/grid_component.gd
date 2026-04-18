extends Node2D
class_name GridComponent

@onready var grid_manager: GridManager = $grid

func _ready() -> void:
	print("Hello Word!")
	print(grid_manager)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos: Vector2 = get_global_mouse_position()
			if grid_manager.can_place(mouse_pos):
				_show_tower_preview(mouse_pos)

func _show_tower_preview(mouse_pos: Vector2):
	var cell_coords = grid_manager.get_grid_cell(mouse_pos)
	var cell_center_pos = grid_manager.get_cell_position_global(mouse_pos)
	print("Posição Célula: ", cell_coords, cell_center_pos)
