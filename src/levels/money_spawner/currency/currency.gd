extends Node2D
class_name Currency

@export var fall_speed: float = 40.0
@export var lifetime: float = 5.0

var _target_y: float = 0.0
var _has_landed: bool = false

func _process(delta: float) -> void:
	if not _has_landed:
		if global_position.y < _target_y:
			global_position.y += fall_speed * delta
		else:
			global_position.y = _target_y
			_start_lifetime_countdown()

func setup(start_position: Vector2, target_y: float) -> void:
	global_position = start_position
	_target_y = target_y

func _start_lifetime_countdown() -> void:
	_has_landed = true
	# TODO: um pouco antes de se auto destruir mudar a animação
	get_tree().create_timer(lifetime).timeout.connect(destroy)

func destroy() -> void:
	queue_free()
