extends Node
class_name WaveManager

@export_category("Config")
@export var level_waves: LevelWavesData

@export_category("Dependency")
@export var enemy_container: Node2D
@export var grid_manager: Node

@onready var lane_spawner: LaneSpawner = $LaneSpawner
@onready var wave_tracker: WaveTracker = $WaveTracker

var _current_wave_index: int = -1
var _current_spawn_queue: Array[EnemyData] = []
var _current_wave_data: WaveData = null
var _is_wave_completed_emitted: bool = false

var _spawn_timer: Timer

func _ready() -> void:
	assert(level_waves != null, "Não foi possível carregar o recurso. Verifique se a propriedade 'level_waves' (LevelWavesData) foi informada.")
	assert(lane_spawner != null, "Não foi possível carregar o componente. Verifique se a propriedade 'lane_spawner' (LaneSpawner) foi informada.")
	assert(wave_tracker != null, "Não foi possível carregar o componente. Verifique se a propriedade 'wave_tracker' (WaveTracker) foi informada.")
	assert(enemy_container != null, 'Não foi possível encontrar a cena. Verifique se a propriedade "enemy_container" foi informada.')
	assert(grid_manager != null, 'Não foi possível encontrar a cena. Verifique se a propriedade "grid_manager" foi informada.')
	
	lane_spawner.setup(enemy_container, grid_manager)
	_setup_timers()

	wave_tracker.wave_time_expired.connect(_on_wave_time_expired)
	wave_tracker.wave_cleared.connect(_on_wave_cleared)

func _setup_timers() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.name = "SpawnTimer"
	add_child(_spawn_timer)
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)

## Começa o nível a partir da primeira onda
func start_level() -> void:
	start_wave(0)

## Inicia uma onda específica pelo seu índice no LevelWavesData
func start_wave(wave_index: int = 0) -> void:
	if level_waves.waves.is_empty():
		push_warning("WaveManager: LevelWavesData não possui ondas cadastradas.")
		return

	if wave_index < 0 or wave_index >= level_waves.waves.size():
		push_error("WaveManager: Índice de onda inválido (%d)" % wave_index)
		return

	_current_wave_index = wave_index
	_current_wave_data = level_waves.waves[_current_wave_index]
	_is_wave_completed_emitted = false

	if not _current_wave_data:
		push_warning("WaveManager: WaveData no índice %d é inválido. Pulando para a próxima wave." % wave_index)
		advance_to_next_wave()
		return

	_current_spawn_queue = WaveBudgetGenerator.generate_spawn_queue(_current_wave_data)

	var is_last_wave: bool = (_current_wave_index == level_waves.waves.size() - 1)
	if wave_tracker:
		wave_tracker.start_tracking(_current_wave_data, is_last_wave)

	_spawn_timer.wait_time = _current_wave_data.spawn_interval
	_spawn_timer.start()

	print("WaveManager: Onda %d iniciada. Orçamento=%d, Inimigos=%d, FlagWave=%s" % [
		_current_wave_index + 1,
		_current_wave_data.total_budget,
		_current_spawn_queue.size(),
		str(_current_wave_data.is_big_wave)
	])

	GameEvents.wave_started.emit(_current_wave_index, _current_wave_data.is_big_wave)

## Avança para a próxima onda ou finaliza se for a última
func advance_to_next_wave() -> void:
	var next_index = _current_wave_index + 1
	if next_index < level_waves.waves.size():
		start_wave(next_index)
	else:
		_spawn_timer.stop()
		if wave_tracker:
			wave_tracker.stop()
		GameEvents.all_waves_completed.emit()

func _on_spawn_timer_timeout() -> void:
	if _current_spawn_queue.is_empty():
		_spawn_timer.stop()
		if wave_tracker:
			wave_tracker.notify_spawn_finished()
		return

	var enemy_to_spawn: EnemyData = _current_spawn_queue.pop_front()
	
	if not lane_spawner:
		push_error("WaveManager: LaneSpawner não está configurado.")
		_spawn_timer.stop()
		return

	var enemy_instance: Node = lane_spawner.spawn_enemy(enemy_to_spawn)
	if enemy_instance and wave_tracker:
		wave_tracker.register_enemy(enemy_instance)

	if _current_spawn_queue.is_empty():
		_spawn_timer.stop()
		if wave_tracker:
			wave_tracker.notify_spawn_finished()

func _on_wave_time_expired() -> void:
	print("WaveManager: Tempo máximo da onda %d excedido." % (_current_wave_index + 1))
	_complete_wave()

func _on_wave_cleared() -> void:
	_complete_wave()

func _complete_wave() -> void:
	if _is_wave_completed_emitted:
		return
	_is_wave_completed_emitted = true

	_spawn_timer.stop()
	if wave_tracker:
		wave_tracker.stop()

	print("WaveManager: Onda %d concluída com sucesso." % (_current_wave_index + 1))
	GameEvents.wave_completed.emit(_current_wave_index)

	advance_to_next_wave()
