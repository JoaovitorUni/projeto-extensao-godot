extends Area2D
class_name AttackComponent

signal attack_started
signal attack_finished

@export var health_component: HealthComponent
@export var movement_component: Node
@export var attack_power: float = 10.0
@export var attack_interval: float = 1.0

var _target_hurtbox: HurtboxComponent = null
var _attack_timer: Timer

func _ready() -> void:
	_attack_timer = Timer.new()
	_attack_timer.one_shot = false
	_attack_timer.wait_time = maxf(0.1, attack_interval)
	_attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(_attack_timer)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func configure(power: float, interval: float) -> void:
	attack_power = power
	attack_interval = maxf(0.1, interval)
	if _attack_timer:
		_attack_timer.wait_time = attack_interval

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent and _target_hurtbox == null:
		_target_hurtbox = area
		_set_movement_active(false)
		_start_attacking()

func _on_area_exited(area: Area2D) -> void:
	if area == _target_hurtbox:
		_target_hurtbox = null
		_stop_attacking()
		_set_movement_active(true)

func _start_attacking() -> void:
	if _attack_timer.is_stopped():
		_execute_attack()
		_attack_timer.start()

func _stop_attacking() -> void:
	if _attack_timer:
		_attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	if is_instance_valid(_target_hurtbox) and _target_hurtbox.health_component and not _target_hurtbox.health_component.is_dead:
		_execute_attack()
	else:
		_target_hurtbox = null
		_stop_attacking()
		_set_movement_active(true)

func _execute_attack() -> void:
	if is_instance_valid(_target_hurtbox):
		_target_hurtbox.take_damage(attack_power)
		attack_started.emit()

func _set_movement_active(active: bool) -> void:
	if movement_component and "is_moving" in movement_component:
		movement_component.is_moving = active
