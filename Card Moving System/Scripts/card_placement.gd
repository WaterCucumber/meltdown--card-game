extends Control
class_name CardPlacement

#const Card_ON_BOARD = preload("uid://2ki75gyvup4c")
const CARD_INSTANCE = preload("uid://cwhrp73vc5wt8")
const PLACEABLE_CARD_INSTANCE = preload("uid://phc71o1tyi8h")

@export var placement_zone := PlaceableCardData.CardZone.NONE
var containing_card : CardInstanceBase

func place_card(card_data: PlaceableCardData) -> PlaceableCardData:
	var temp_card : Control = CARD_INSTANCE.instantiate()
	temp_card.set_script(PLACEABLE_CARD_INSTANCE)
	temp_card.position = Vector2.ONE * 3
	add_child(temp_card)
	containing_card = temp_card
	return temp_card.initialize(card_data, false)


func _on_mouse_entered() -> void:
	if containing_card: return

	if not Board.instance.selected_card: return
	var current_card : CardDataBase = Board.instance.selected_card.card_data
	if not current_card: return
	if current_card is not PlaceableCardData: return

	var can_set := placement_zone == PlaceableCardData.CardZone.ANYWHERE
	can_set = can_set or current_card.card_zone == PlaceableCardData.CardZone.ANYWHERE
	can_set = can_set or current_card.card_zone == placement_zone
	if can_set:
		Board.instance.mouse_on_placement = self


func _on_mouse_exited() -> void:
	if Board.instance.mouse_on_placement == self:
		Board.instance.mouse_on_placement = null
