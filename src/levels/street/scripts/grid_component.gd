extends Node2D
class_name  GridComponent

@onready var grid_manager: GridManager = $grid

func _ready() -> void:
	print("Hello Word!")
	print(grid_manager)
