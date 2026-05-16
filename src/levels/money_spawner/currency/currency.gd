extends Node2D
class_name Currency

@export var fall_speed: float = 40.0
@export var lifetime: float = 8.0

var _target_y: float = 0.0

func _ready() -> void:
	# TODO: um pouco antes de se auto destruir mudar a animação
	get_tree().create_timer(lifetime).timeout.connect(destroy)

func _process(delta: float) -> void:
	if global_position.y < _target_y:
		global_position.y += fall_speed * delta

func setup(start_position: Vector2, target_y: float) -> void:
	global_position = start_position
	_target_y = target_y

func destroy() -> void:
	queue_free()
