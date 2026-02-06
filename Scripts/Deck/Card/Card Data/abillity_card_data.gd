@abstract
extends CardDataBase
class_name AbillityCardData

@export var card_use : Array[CardUseBase]

func use():
	for i in card_use:
		i._on_use()
