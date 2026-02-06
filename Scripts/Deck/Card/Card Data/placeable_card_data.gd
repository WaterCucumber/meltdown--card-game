@abstract extends CardDataBase
class_name PlaceableCardData

enum CardZone {
	NONE,
	ANYWHERE,
	COOLING,
	CONTROL,
	GENERATION,
	SAFETY,
	REPAIR,
}

const zone_to_color : Dictionary[CardZone, Color] = {
	CardZone.NONE : Color.DEEP_PINK,
	CardZone.ANYWHERE : Color(0.773, 0.773, 0.773, 1.0),
	CardZone.COOLING : Color(0.484, 0.843, 1.0),
	CardZone.CONTROL : Color(0.654, 0.91, 0.754),
	CardZone.GENERATION : Color(0.848, 0.879, 0.57),
	CardZone.SAFETY : Color(0.0, 0.691, 0.27),
	CardZone.REPAIR : Color(0.6, 0.775, 0.844),
}

@export var card_use: Array[PlaceableCardUse] = []
@export var card_zone := CardZone.NONE
