extends PanelContainer
class_name PlacementZone

const Card_PLACEMENT = preload("uid://cd6gfvs7ctona")

@export var zone_key := ""
@export var zone_type := PlaceableCardData.CardZone.NONE
@export var places_count := 4
@export var zone_color : Color
@onready var places: HBoxContainer = $ColorRect/VBC/HBC
@onready var name_label: Label = $ColorRect/VBC/Label
@onready var color_rect: ColorRect = $ColorRect
@onready var nine_patch_rect: NinePatchRect = $ColorRect/NinePatchRect


func _ready() -> void:
	name_label.text = tr(zone_key)
	color_rect.color = zone_color
	nine_patch_rect.self_modulate = zone_color
	generate_places()
	Board.instance.card_taken.connect(_on_card_selected)
	Board.instance.card_dropped.connect(_on_card_dropped)


func _on_card_selected(card: CardInstanceBase):
	if card.card_data is PlaceableCardData:
		if card.card_data.card_zone == zone_type: return
	modulate = Color(0.34, 0.34, 0.34, 1.0)


func _on_card_dropped():
	modulate = Color.WHITE


func generate_places():
	for i in places_count:
		create_place()


func create_place():
	var Card_placement : CardPlacement = Card_PLACEMENT.instantiate()
	Card_placement.placement_zone = zone_type
	places.add_child(Card_placement)
