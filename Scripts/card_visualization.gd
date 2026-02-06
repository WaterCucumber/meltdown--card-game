extends TextureRect
class_name CardVisualization

@onready var Card_outline: TextureRect = $CardOutline
@onready var Card_effect: TextureRect = $CardEffect
@onready var Card_image: TextureRect = $CardImage
@onready var name_label: RichTextLabel = %NameLabel
@onready var description_label: RichTextLabel = %DescriptionLabel
@onready var cost_label: RichTextLabel = $Cost/CostLabel

func initialize(card: CardDataBase):
	if card is PlaceableCardData:
		self_modulate = card.zone_to_color[card.card_zone]
	else:
		self_modulate = Color(0.723, 0.723, 0.723)
	Card_outline.self_modulate = card.type_to_color[card.get_type()]
	Card_effect.texture = card.effect_texture
	Card_image.texture = card.texture
	# Локализуем имя и описание карты (если они статические в CardDataBase)
	name_label.text = card.cashed_name  # Предполагаем, что CardInstanceBase.name_key — ключ, например "Card_fireball_name"
	name_label.self_modulate = Color(self_modulate * 0.5, 1)
	description_label.text = "[color=%s]" % Color(self_modulate * 0.5, 1).to_html()
	description_label.text += unparse(card.description)
	description_label.text += "[/color]"
	cost_label.text = str(card.cost)  # Цифры обычно не переводятся

const ACTION_POINTS = "[color=white][img]uid://bcnvwynyan8ct[/img][/color]"
const ENERGY = "[color=white][img]uid://cjeany6nlhm51[/img][/color]"
const RADIATION = "[color=white][img]uid://4b7uts7cdjqx[/img][/color]"
const SAFETY_POINTS = "[color=white][img]uid://bpi1lr43cli1r[/img][/color]"
const TEMPERATURE = "[color=white][img]uid://cw0lsjke5mkvm[/img][/color]"
const VICTORY_POINTS = "[color=white][img]uid://b1ow4gnjrlkag[/img][/color]"

# /a -> ACTION_POINTS. /s -> SAFETY_POINTS
func unparse(text: String) -> String:
	var result = text
	result = result.replace("/a", ACTION_POINTS)
	result = result.replace("/s", SAFETY_POINTS)
	result = result.replace("/e", ENERGY)
	result = result.replace("/r", RADIATION)
	result = result.replace("/t", TEMPERATURE)
	result = result.replace("/v", VICTORY_POINTS)
	return result
