extends Node

@export_category("Configurações de Debug")
@export var enable_tower_logs: bool = false
@export var enable_economy_logs: bool = false
@export var enable_wave_logs: bool = false
@export var enable_level_logs: bool = false

func _ready() -> void:
	if enable_tower_logs:
		_setup_tower_logs()
	if enable_economy_logs:
		_setup_economy_logs()
	if enable_wave_logs:
		_setup_wave_logs()
	if enable_level_logs:
		_setup_level_logs()

func _setup_tower_logs() -> void:
	GameEvents.tower_grabbed.connect(func(tower_data: TowerData):
		print("Debug [Tower]: tower_grabbed - TowerData: %s" % tower_data.name)
	)
	GameEvents.tower_placed.connect(func(tower_data: TowerData):
		print("Debug [Tower]: tower_placed - TowerData: %s" % tower_data.name)
	)
	GameEvents.tower_dropped.connect(func():
		print("Debug [Tower]: tower_dropped")
	)

func _setup_economy_logs() -> void:
	GameEvents.tower_purchase_requested.connect(func(tower_data: TowerData):
		print("Debug [Economy]: tower_purchase_requested - TowerData: %s" % tower_data.name)
	)
	GameEvents.tower_purchase_approved.connect(func(tower_data: TowerData):
		print("Debug [Economy]: tower_purchase_approved - TowerData: %s" % tower_data.name)
	)
	GameEvents.tower_purchase_denied.connect(func(tower_data: TowerData):
		print("Debug [Economy]: tower_purchase_denied - TowerData: %s" % tower_data.name)
	)
	GameEvents.currency_collected.connect(func(value: int):
		print("Debug [Economy]: currency_collected - Value: %d" % value)
	)
	GameEvents.currency_changed.connect(func(new_currency: int):
		print("Debug [Economy]: currency_changed - New Currency: %d" % new_currency)
	)

func _setup_wave_logs() -> void:
	GameEvents.wave_started.connect(func(wave_index: int, is_flag_wave: bool):
		print("Debug [Wave]: wave_started - Index: %s, Flag Wave: %s" % [wave_index, is_flag_wave])
	)
	GameEvents.wave_completed.connect(func(wave_index: int):
		print("Debug [Wave]: wave_completed - Index: %s" % wave_index)
	)
	GameEvents.all_waves_completed.connect(func():
		print("Debug [Wave]: all_waves_completed")
	)

func _setup_level_logs() -> void:
	GameEvents.level_victory.connect(func():
		print("Debug [Level]: level_victory")
	)
	GameEvents.level_defeat.connect(func():
		print("Debug [Level]: level_defeat")
	)
	GameEvents.base_breached.connect(func():
		print("Debug [Level]: base_breached")
	)
