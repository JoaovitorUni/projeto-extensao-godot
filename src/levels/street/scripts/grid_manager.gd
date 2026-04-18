extends TileMapLayer
class_name GridManager

var _placed_objects: Dictionary = {}

func is_within_grid(global_pos: Vector2) -> bool:
	var local_pos = to_local(global_pos)
	var cell = local_to_map(local_pos)
	var used_rect: Rect2i = get_used_rect()
	return used_rect.has_point(cell)

func get_grid_cell(cursor_position: Vector2) -> Vector2i:
	return local_to_map(cursor_position)

func can_place(cursor_position: Vector2) -> bool:
	if is_within_grid(cursor_position):
		var cell = get_grid_cell(cursor_position)
		if not _placed_objects.has(cell):
			return true
	return false

func get_cell_position(cursor_position: Vector2) -> Vector2:
	var cell = get_grid_cell(cursor_position)
	return map_to_local(cell)

func place(cursor_position: Vector2, node: Node2D):
	var cell = get_grid_cell(cursor_position)
	_placed_objects[cell] = node
