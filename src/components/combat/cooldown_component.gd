extends Node
class_name CooldownComponent

signal cooldown_finished

@export var cooldown_time: float = 1.0
@export var autostart: bool = false

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.name = "Timer"
	_timer.wait_time = maxf(0.01, cooldown_time)
	_timer.one_shot = false
	_timer.autostart = autostart
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)

func start(trigger_immediately: bool = false) -> void:
	if _timer.is_stopped():
		if trigger_immediately:
			cooldown_finished.emit()
		_timer.start()

func stop() -> void:
	if not _timer.is_stopped():
		_timer.stop()

func set_cooldown(time: float) -> void:
	cooldown_time = time
	if is_instance_valid(_timer):
		_timer.wait_time = maxf(0.01, cooldown_time)

func _on_timer_timeout() -> void:
	cooldown_finished.emit()
