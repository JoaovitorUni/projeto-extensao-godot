extends Node
class_name LinearMovementComponent

const LEFT = Vector2.LEFT
const RIGHT = Vector2.RIGHT
const UP = Vector2.UP
const DOWN = Vector2.DOWN

@export var target_node: Node2D
@export var speed: float = 0.0
@export var direction: Vector2 = LEFT

var is_moving: bool = true

func _physics_process(delta: float) -> void:
	if not is_moving or not target_node:
		return
	
	target_node.global_position += direction.normalized() * speed * delta

func pause() -> void:
	is_moving = false

func resume() -> void:
	is_moving = true

func set_speed(new_speed: float) -> void:
	speed = maxf(0.0, new_speed)

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()
