extends HBoxContainer
class_name CardContainer

const CARD_INSTANCE = preload("uid://cwhrp73vc5wt8")
const PLACEABLE_CARD_INSTANCE = preload("uid://phc71o1tyi8h")

var start_pos : Vector2
var max_cards_allowed := 6

var cards_down := false

func place_card(card_data: PlaceableCardData):
	var temp_card : Control = CARD_INSTANCE.instantiate()
	temp_card.set_script(PLACEABLE_CARD_INSTANCE)
	temp_card.position = Vector2.ONE * 3
	add_child(temp_card)
	temp_card.initialize(card_data, true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hide_cards"):
		toggle_cards(not cards_down)


func _ready() -> void:
	start_pos = get_parent().position
	PlayerStats.inventory.ValuesChanged.connect(_on_stats_changed)


func _on_stats_changed():
	if PlayerStats.inventory.action_points.Value > 0:
		modulate = Color.WHITE
	else:
		modulate = Color.WEB_GRAY


func toggle_cards(down: bool):
	cards_down = down
	var tween := get_tree().create_tween()
	var tween2 := get_tree().create_tween()
	tween.tween_property(get_parent(), "position", start_pos + Vector2.DOWN * size.y * float(down), 0.2)
	tween2.tween_property(get_parent(), "scale", Vector2.ONE, 0.2)


func fade(to_hide: bool):
	var to = 1 - float(to_hide)
	var tween := get_tree().create_tween()
	tween.tween_property(get_parent(), "modulate:a", to, 0.2)


func move_down():
	toggle_cards(true)


func move_up():
	if get_child_count() > 0:
		toggle_cards(false)


func _on_card_mouse_enter():
	fade(true)
