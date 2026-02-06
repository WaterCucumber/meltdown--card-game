extends Node

const CARD_INSTANCE = preload("uid://cwhrp73vc5wt8")
const ABILLITY_CARD = preload("uid://4modck1vftfg")
const PLACEABLE_CARD = preload("uid://phc71o1tyi8h")

@export var decks : Decks
@export var card_container: CardContainer
var current_deck : Deck

func _ready() -> void:
	current_deck = decks.get_random()
	print("Chosen deck: ", current_deck.name)
	add_cards(true)


func add_cards(start := false):
	if start and current_deck.total_cards().is_empty(): 
		return
	if current_deck.total_cards().is_empty(): return
	var count : int = 5 if start else mini(PlayerStats.inventory.action_points.Value, 5)
	for i in count:
		create_card()


func create_card():
	var data : CardDataBase = current_deck.pop_random_card()

	if not data: return

	var card : Control = CARD_INSTANCE.instantiate()
	card.set_script(PLACEABLE_CARD if data is PlaceableCardData else ABILLITY_CARD)
	card_container.add_child(card)
	card.initialize(data, true)


func _on_next_turn_button_pressed() -> void:
	add_cards()
