extends Node

signal tower_grabbed(data: TowerData)
signal tower_placed(data: TowerData)
signal tower_dropped()
signal tower_purchased(cost: int)
signal tower_died(tower_node: Node2D)

signal tower_purchase_requested(tower_data: TowerData)
signal tower_purchase_approved(tower_data: TowerData)
signal tower_purchase_denied(tower_data: TowerData)
signal currency_collected(value: int)
signal currency_changed(new_currency: int)
signal currency_generated(value: int)

signal enemy_spawned(enemy_node: Node)
signal enemy_died(enemy_node: Node)

signal wave_started(wave_index: int, is_flag_wave: bool)
signal wave_completed(wave_index: int)
signal all_waves_completed

signal level_victory
signal level_defeat

signal base_breached
