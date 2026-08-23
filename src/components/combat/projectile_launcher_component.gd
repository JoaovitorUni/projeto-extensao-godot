extends Node2D
class_name ProjectileLauncherComponent

@export var projectile_scene: PackedScene
@export var spawn_point: Marker2D

func _ready() -> void:
	if spawn_point == null:
		spawn_point = $Marker2D
	assert(spawn_point != null, "Não foi possível carregar o componente. Verifique se a propriedade 'lane_spawner' (LaneSpawner) foi informada.")

## Instancia o projétil e o adiciona na camada de jogo.
func launch() -> void:
	if not projectile_scene:
		push_warning("ProjectileLauncherComponent: 'projectile_scene' não está configurada.")
		return

	var projectile_instance := projectile_scene.instantiate() as Node2D
	var launch_pos = spawn_point.global_position

	projectile_instance.global_position = launch_pos

	GameLayers.add_child_projectile(projectile_instance)
