extends Node
class_name LaneSpawner

var enemy_container: Node2D
var grid_manager: GridManager

func setup(p_enemy_container: Node2D, p_grid_manager: GridManager):
	enemy_container = p_enemy_container
	grid_manager = p_grid_manager
	_validate_grid_manager_contract()

func spawn_enemy(enemy_data: EnemyData) -> Node:
	if not enemy_data or not enemy_data.scene:
		push_warning("LaneSpawner: EnemyData ou cena inválidos.")
		return null

	var lanes: Array[int] = grid_manager.get_lanes()
	var chosen_lane: int = lanes.pick_random()
	var spawn_pos: Vector2 = grid_manager.get_lane_spawn_position(chosen_lane)

	var enemy_instance: Node = enemy_data.instantiate_entity()
	enemy_instance.global_position = spawn_pos

	enemy_container.add_child(enemy_instance)
	
	return enemy_instance

func _validate_grid_manager_contract() -> void:
	var lanes: Array[int] = grid_manager.get_lanes()
	assert(not lanes.is_empty(), "O Grid precisa ter ao menos uma linha.")
