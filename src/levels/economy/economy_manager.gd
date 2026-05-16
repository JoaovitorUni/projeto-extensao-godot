extends Node
class_name EconomyManager

var current_currency: int = 0:
	set(value):
		current_currency = max(0, value)

func add_currency(amount: int) -> void:
	current_currency += amount

func subtract_currency(amount: int) -> void:
	current_currency -= amount

func has_enough_currency(amount: int) -> bool:
	return current_currency >= amount
