extends TileMapLayer
class_name GridManager

var _placed_objects: Dictionary = {}

func get_grid_cell(cursor_position: Vector2) -> Vector2i:
	return local_to_map(cursor_position)

func can_place(cursor_position: Vector2) -> bool:
	var cell = get_grid_cell(cursor_position)
	if _placed_objects.has(cell):
		return false
	return true

func get_cel_position(cursor_position: Vector2) -> Vector2:
	var cell = get_grid_cell(cursor_position)
	return map_to_local(cell)

func place(cursor_position: Vector2, node: Node2D):
	var cell = get_grid_cell(cursor_position)
	_placed_objects[cell] = node
