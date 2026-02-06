extends Node

func _ready() -> void:
	PlayerStats.value_reached_limit.connect(on_value_reached_limit)


func on_value_reached_limit(c: Currency):
	if c.type.positive:
		if c.type == PlayerStats.inventory.energy.type:
			GameOver.win_game("energy-reached-100")
	else:
		GameOver.lose_game()
