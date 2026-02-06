extends CardInstanceBase
class_name AbillityCardInstance

func _on_successful_mouse_up():
	if card_data and card_data is not PlaceableCardData:
		# Use CardInstanceBase
		queue_free()
		card_data.use()
		_remove_card_cost()
	else:
		_on_unsuccessful_mouse_up()


func _on_unsuccessful_mouse_up():
	deselect_card()


func _on_rmb():
	print("Nope")
