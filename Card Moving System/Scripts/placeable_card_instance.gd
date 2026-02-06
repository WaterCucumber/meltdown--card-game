extends CardInstanceBase
class_name PlaceableCardInstance

func initialize(card: CardDataBase, card_container : bool) -> CardDataBase:
	if card is not PlaceableCardData:
		push_warning("No PlaceableCardData!")
		return
	card_data = card.duplicate(true)
	card_data._cashed_name = card.cashed_name
	for i in card_data.card_use:
		Board.instance.turn_ended.connect(i._on_turn_ended)
		Board.instance.turn_started.connect(i._on_turn_started)
	card_visualization.initialize(card)
	in_card_container = card_container
	_on_data_changed()
	PlayerStats.inventory.ValuesChanged.connect(_on_data_changed)
	return card_data


func _exit_tree() -> void:
	if in_card_container: return
	for i in card_data.card_use:
		i._on_removed()


func _on_rmb():
	if PlayerStats.inventory.action_points.Value == 0: return
	if not in_card_container: 
		PlayerStats.inventory.action_points.Value -= 1
		PlayerStats.inventory.energy.Value += card_data.cost
	board.card_container.move_up()
	queue_free()
	board.card_container.place_card(card_data)
	clear_card_holder()


func _on_successful_mouse_up():
	if board.mouse_on_placement:
		# Place Card on the board
		var d : PlaceableCardData = board.mouse_on_placement.place_card(card_data)
		if in_card_container: _remove_card_cost()
		else: PlayerStats.inventory.action_points.Value -= 1
		
		for i in d.card_use:
			i._on_placed()
		queue_free()
	else:
		_on_unsuccessful_mouse_up()


func _on_unsuccessful_mouse_up():
	deselect_card()
