extends Node
class_name LevelManager

enum LevelState {PLAYING, VICTORY, DEFEAT}
var current_state: LevelState = LevelState.PLAYING

func _ready() -> void:
	GameEvents.all_waves_completed.connect(_on_all_waves_completed)
	GameEvents.base_breached.connect(_on_base_breached)

func _on_all_waves_completed() -> void:
	if current_state != LevelState.PLAYING:
		return

	current_state = LevelState.VICTORY
	print("LevelManager: Condição de VITÓRIA alcançada!")

	GameEvents.level_victory.emit()

func _on_base_breached() -> void:
	if current_state != LevelState.PLAYING:
		return

	current_state = LevelState.DEFEAT
	print("LevelManager: Condição de DERROTA alcançada! Inimigo invadiu a base.")

	GameEvents.level_defeat.emit()
