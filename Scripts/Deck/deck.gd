extends Resource
class_name Deck

@export var name := ""
@export var staff_cards: Array[StaffCardData]
@export var equipment_cards: Array[EquipmentCardData]
@export var event_cards: Array[EventCardData]
@export var crises_cards: Array[CrisesCardData]

func total_cards() -> Array[CardDataBase] :
	var flattened: Array[CardDataBase] = []
	flattened.append_array(staff_cards)
	flattened.append_array(equipment_cards)
	flattened.append_array(event_cards)
	flattened.append_array(crises_cards)
	return flattened


func pop_random_card(type := CardDataBase.CardType.NONE) -> CardDataBase:
	match type:
		CardDataBase.CardType.STAFF:
			return staff_cards.pop_at(randi_range(0, staff_cards.size() - 1))
		CardDataBase.CardType.EQUIPMENT:
			return equipment_cards.pop_at(randi_range(0, equipment_cards.size() - 1))
		CardDataBase.CardType.EVENT:
			return event_cards.pop_at(randi_range(0, event_cards.size() - 1))
		CardDataBase.CardType.CRISES:
			return crises_cards.pop_at(randi_range(0, crises_cards.size() - 1))
	var rand := randf()
	if not crises_cards.is_empty() and rand <= 0.16:
		return crises_cards.pop_at(randi_range(0, crises_cards.size() - 1))
	if not event_cards.is_empty() and rand <= 0.36:
		return event_cards.pop_at(randi_range(0, event_cards.size() - 1))
	if not equipment_cards.is_empty() and rand <= 0.68:
		return equipment_cards.pop_at(randi_range(0, equipment_cards.size() - 1))
	return staff_cards.pop_at(randi_range(0, staff_cards.size() - 1))
