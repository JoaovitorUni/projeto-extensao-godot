extends TileMapLayer
class_name GridManager

var _placed_objects: Dictionary = {}

func is_within_grid(global_pos: Vector2) -> bool:
	var local_pos = to_local(global_pos)
	var cell = local_to_map(local_pos)
	var used_rect: Rect2i = get_used_rect()
	return used_rect.has_point(cell)

func get_grid_cell(global_pos: Vector2) -> Vector2i:
	var local_pos = to_local(global_pos)
	return local_to_map(local_pos)

func can_place(global_pos: Vector2) -> bool:
	if is_within_grid(global_pos):
		var cell = get_grid_cell(global_pos)
		if not _placed_objects.has(cell):
			return true
	return false

func get_cell_position(global_pos: Vector2) -> Vector2:
	var cell = get_grid_cell(global_pos)
	return map_to_local(cell)

func get_cell_position_global(global_pos: Vector2) -> Vector2:
	var cell = get_grid_cell(global_pos)
	return to_global(map_to_local(cell))

func place(global_pos: Vector2, node: Node2D):
	var cell = get_grid_cell(global_pos)
	_placed_objects[cell] = node
