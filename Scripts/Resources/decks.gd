extends Resource
class_name Decks

@export var decks : Array[Deck]


func get_random() -> Deck:
	return decks.pick_random().duplicate(true)
