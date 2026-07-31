extends Area2D
class_name AttackComponent

# Emitido imediatamente antes de um ataque ser executado.
signal attack_started
# Emitido quando o timer de ataque para (alvo perdido ou destruído).
signal attack_finished
# Emitido quando um alvo entra no alcance.
signal target_acquired
# Emitido quando o alvo sai do alcance ou morre.
signal target_lost

@export var attack_power: float = 10.0
@export var attack_interval: float = 1.0
@export var faction: LevelLayers.Faction = LevelLayers.Faction.TOWER

var _target_hurtbox: HurtboxComponent = null
var _attack_timer: Timer

func _ready() -> void:
	match faction:
		LevelLayers.Faction.TOWER:
			collision_layer = LevelLayers.LAYER_TOWER_ATTACK
			collision_mask = LevelLayers.LAYER_ENEMY_HURTBOX
		LevelLayers.Faction.ENEMY:
			collision_layer = LevelLayers.LAYER_ENEMY_ATTACK
			collision_mask = LevelLayers.LAYER_TOWER_HURTBOX

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
		target_acquired.emit()
		_start_attacking()

func _on_area_exited(area: Area2D) -> void:
	if area == _target_hurtbox:
		_target_lost()

func _start_attacking() -> void:
	if _attack_timer.is_stopped():
		_execute_attack()
		_attack_timer.start()

func _stop_attacking() -> void:
	if _attack_timer:
		_attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	if is_instance_valid(_target_hurtbox) and not _target_hurtbox.health_component.is_dead:
		_execute_attack()
	else:
		_target_lost()

func _execute_attack() -> void:
	if is_instance_valid(_target_hurtbox):
		_target_hurtbox.take_damage(attack_power)
		attack_started.emit()

func _target_lost() -> void:
	_target_hurtbox = null
	_stop_attacking()
	attack_finished.emit()
	target_lost.emit()

func set_attack_range(radius: float) -> void:
	var shape := $CollisionShape2D as CollisionShape2D
	if shape and shape.shape is RectangleShape2D:
		(shape.shape as RectangleShape2D).size = Vector2(radius * 2.0, radius * 2.0)
