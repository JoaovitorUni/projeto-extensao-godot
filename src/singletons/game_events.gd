extends Node

signal tower_grabbed(data: TowerData)
signal tower_placed(data: TowerData)
signal tower_dropped()
signal tower_purchased(cost: int)

signal tower_purchase_requested(tower_data: TowerData)
signal tower_purchase_approved(tower_data: TowerData)
signal tower_purchase_denied(tower_data: TowerData)
