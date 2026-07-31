extends Node
class_name HealthComponent

signal health_changed(current: float, max_hp: float)
signal died

@export var max_health: float = 100.0
var current_health: float
var is_dead: bool = false

func _ready() -> void:
	if current_health <= 0.0 and not is_dead:
		current_health = max_health

func initialize(hp: float) -> void:
	max_health = hp
	current_health = max_health
	is_dead = false
	health_changed.emit(current_health, max_health)

func take_damage(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	
	current_health = clampf(current_health - amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0.0:
		is_dead = true
		died.emit()

func heal(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	
	current_health = clampf(current_health + amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)
