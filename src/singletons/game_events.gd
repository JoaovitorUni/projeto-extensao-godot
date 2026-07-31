extends Node

signal tower_grabbed(data: TowerData)
signal tower_placed(data: TowerData)
signal tower_dropped()
signal tower_purchased(cost: int)

signal tower_purchase_requested(tower_data: TowerData)
signal tower_purchase_approved(tower_data: TowerData)
signal tower_purchase_denied(tower_data: TowerData)
signal currency_collected(value: int)
signal currency_changed(new_currency: int)
signal currency_generated(value: int)

signal enemy_spawned(enemy: Node2D)
signal enemy_died(enemy: Node2D)
