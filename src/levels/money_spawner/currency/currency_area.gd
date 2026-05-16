extends Area2D

@export var value: int = 25
var _is_collected: bool = false

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if _is_collected:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_collect()

func _collect() -> void:
	_is_collected = true
	GameEvents.currency_collected.emit(value)

	if owner:
		owner.queue_free()
	else:
		get_parent().queue_free()
