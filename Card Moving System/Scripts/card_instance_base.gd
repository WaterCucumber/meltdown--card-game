@abstract extends Control
class_name CardInstanceBase

const CARD_HOLDER = preload("uid://ddjsye4fvh10x")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var board := Board.instance
@onready var card_visualization: CardVisualization = $CardVisualization

var card_data: CardDataBase
var start_pos : Vector2
var start_size := Vector2.ZERO
var card_highlighted := false
var mouse_on := false
var tween : Tween = null

var in_card_container := true

func initialize(card: CardDataBase, card_container : bool) -> CardDataBase:
	if card is not CardDataBase:
		push_warning("No CardDataBase!")
		return
	card_data = card.duplicate(true)
	if card is PlaceableCardData:
		for i in card_data.card_use:
				Board.instance.turn_ended.connect(i._on_turn_ended)
				Board.instance.turn_started.connect(i._on_turn_started)
	card_visualization.initialize(card)
	in_card_container = card_container
	_on_data_changed()
	PlayerStats.inventory.ValuesChanged.connect(_on_data_changed)
	return card_data


func _on_data_changed():
	if (not in_card_container 
			or can_remove_card_cost()):
		modulate = Color.WHITE
	else:
		modulate = Color.WEB_GRAY


func _ready() -> void:
	await get_tree().process_frame
	update_minimum_size()
	if start_size == Vector2.ZERO: start_size = card_visualization.size


func _on_mouse_entered() -> void:
	mouse_on = true
	z_index += 5
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(card_visualization, "size", start_size * 1.5, 0.2)
	animation_player.play("select")
	card_highlighted = true


func _on_mouse_exited() -> void:
	mouse_on = false
	z_index -= 5
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(card_visualization, "size", start_size, 0.2)
	animation_player.play("deselect")
	card_highlighted = false


func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.button_mask == 1 and can_move():
			# Down
			if card_highlighted:
				var temp_card := CARD_HOLDER.instantiate()
				board.card_holder.add_child(temp_card)
				temp_card.initialize(card_data)
				board.select_card(self)
				get_child(0).hide()
				board.card_container.move_down()
		elif event.button_mask == 0:
			board.card_container.move_up()
			if can_move():
				_on_successful_mouse_up()
				clear_card_holder()
			else:
				_on_unsuccessful_mouse_up()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		_on_rmb()


@abstract func _on_successful_mouse_up()
@abstract func _on_unsuccessful_mouse_up()
@abstract func _on_rmb()


func can_remove_card_cost() -> bool:
	var inv := PlayerStats.inventory
	return inv.action_points.Value > 0 and inv.energy.Value >= card_data.cost


func can_move() -> bool:
	return (can_remove_card_cost() or 
				(not in_card_container 
				and PlayerStats.inventory.action_points.Value > 0))


func _remove_card_cost():
	PlayerStats.inventory.action_points.Value -= 1
	PlayerStats.inventory.energy.Value -= card_data.cost


func deselect_card():
	card_highlighted = mouse_on
	get_child(0).show()


func clear_card_holder():
	for i in board.card_holder.get_children():
		i.queue_free()
	board.deselect_card()
