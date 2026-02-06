extends Node

const GLOBAL_DIFFICULTY = preload("uid://blwnulgp4u1nm")
var global_difficulty : GlobalDifficulty
@onready var next_turn_button: Button = $"../UI/Game/Stats/MarginContainer/VBoxContainer/NextTurnButton"

@export var coef := 1.0
var next_rnd : float

func _ready() -> void:
	global_difficulty = GLOBAL_DIFFICULTY.duplicate()
	next_turn_button.pressed.connect(_on_next_turn)
	global_difficulty.difficulty_updated.connect(_on_difficulty_changed)
	next_rnd = get_next_offset()
	_on_difficulty_changed(global_difficulty.difficulty_factor(), true)

var turn_i := 0.0
func _on_next_turn():
	turn_i += next_rnd
	next_rnd = get_next_offset()
	global_difficulty.grow_dynamic_difficulty(0.5, 1.3, sin(turn_i))


func get_next_offset():
	return randf()


func get_next_factor() -> float:
	return global_difficulty.get_next_factor(0.5, 1.3, sin(turn_i + next_rnd))


func _on_difficulty_changed(factor: float, first := false):
	#Stats.set_stat_v(Stats.Stat.AP, int(5 * 1 / factor), PlayerStats.instance.difficulty_data)
	var inv := PlayerStats.difficulty_inventory
	var dif : float = PlayerStats.inventory.difficulty.Value
	if not first:
		PlayerStats.inventory_to_pending(inv, true)
	inv.temperature.Value = coef * factor
	inv.radiation.Value = coef * factor / 2.0
	inv.victory_points.Value = factor / 100.0
	inv.action_points.Value = ceili(5 / factor)
	inv.difficulty.Value = get_next_factor() - dif
	#print("Difficulty: ", global_difficulty.difficulty_factor()	)
	PlayerStats.inventory_to_pending(inv)
	PlayerStats.inventory.ValuesChanged.emit()
	#Stats.set_stat_v(Stats.Stat.VP, factor / 100.0, PlayerStats.instance.difficulty_data)
