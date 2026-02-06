extends Control

@onready var card_base: CardVisualization = $CardBase


func initialize(card_data: CardDataBase):
	if card_data:
		card_base.initialize(card_data)


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() - size / 2
