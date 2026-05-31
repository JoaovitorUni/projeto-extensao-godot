extends PanelContainer
class_name CurrencyCounter

@onready var amount_label: Label = $HBoxContainer/AmountLabel

func _ready() -> void:
	GameEvents.currency_changed.connect(_on_currency_changed)
	# TODO: Dinamizar, por exemplo se um levels inicia o EconomyComponent com initial_currency = 100 a UI ficaria desatualizada.
	_update_currency(0)

func _on_currency_changed(new_currency: int) -> void:
	_update_currency(new_currency)

func _update_currency(value: int) -> void:
	amount_label.text = str(value)
