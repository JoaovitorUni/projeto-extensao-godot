extends Node
class_name WaveTracker

signal wave_time_expired
signal wave_cleared

var _tracked_enemies: Array[Node] = []
var _is_last_wave: bool = false
var _is_spawning_finished: bool = false
var _duration_timer: Timer

func _ready() -> void:
	_duration_timer = Timer.new()
	_duration_timer.name = "DurationTimer"
	_duration_timer.one_shot = true
	add_child(_duration_timer)
	_duration_timer.timeout.connect(_on_duration_timer_timeout)

func start_tracking(wave_data: WaveData, is_last_wave: bool) -> void:
	_tracked_enemies.clear()
	_is_last_wave = is_last_wave
	_is_spawning_finished = false
	
	if wave_data.max_duration > 0.0:
		_duration_timer.wait_time = wave_data.max_duration
		_duration_timer.start()
	else:
		_duration_timer.stop()

func register_enemy(enemy_node: Node) -> void:
	if not _tracked_enemies.has(enemy_node):
		_tracked_enemies.append(enemy_node)
		enemy_node.tree_exited.connect(_on_enemy_tree_exited.bind(enemy_node))

func notify_spawn_finished() -> void:
	_is_spawning_finished = true
	_check_wave_cleared()

func _on_enemy_tree_exited(enemy_node: Node) -> void:
	if _tracked_enemies.has(enemy_node):
		_tracked_enemies.erase(enemy_node)
	_check_wave_cleared()

func _check_wave_cleared() -> void:
	if _is_spawning_finished and _tracked_enemies.is_empty():
		_duration_timer.stop()
		wave_cleared.emit()

func _on_duration_timer_timeout() -> void:
	if not _is_last_wave:
		wave_time_expired.emit()
	else:
		# Comportamento especial: na última onda, o tempo estourar não avança
		# o jogo automaticamente. Apenas esperamos o jogador matar todos os inimigos.
		pass

func stop() -> void:
	_duration_timer.stop()
	_tracked_enemies.clear()
