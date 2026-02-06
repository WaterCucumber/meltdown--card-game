extends ColorRect
class_name GameOver

signal game_over(won: bool)
signal game_lost
signal game_won

static var instance: GameOver

const GAME_OVER_SEPARATOR = preload("uid://d21jrtu0prhmy")

@onready var gg_stats_label: RichTextLabel = %GGStatsLabel
@onready var again_button: Button = %AgainButton
@onready var state_label: RichTextLabel = $Lost/Centre/StateLabel
@onready var transition: ShaderTransition = %Transition

var is_game_over := false
var is_game_won := false

func _init() -> void:
	instance = self
	hide()


func _ready() -> void:
	pass


func _on_game_over(won : bool, break_case: String):
	transition.transition()
	await transition.transition_ended
	transition.reversed_transition()
	show()
	gg_stats_label.text = ""
	is_game_over = true
	is_game_won = won
	var v = GAME_OVER_SEPARATOR
	if is_game_won:
		game_won.emit()
		state_label.text = "[color=green][shake][b][font_size=128]!WON!"
		v.color = Color.GREEN
	else:
		game_lost.emit()
		v.color = Color.RED
		state_label.text = "[color=red][shake][b][font_size=128]!LOST!"
	write_message(break_case)
	await transition.reversed_transition_ended
	game_over.emit(game_won)


func write_message(break_case : String):
	var tween := get_tree().create_tween()
	gg_stats_label.text = generate_message(break_case)
	gg_stats_label.visible_characters = 0
	tween.tween_property(gg_stats_label, "visible_ratio", 1, 4)


func generate_message(break_case : String) -> String:
	var start := "[color=light_gray][wave][font_size=64][b]%s[/b][/font_size][/wave]" % "---GAME-OVER---"
	var end_case := ("%s: " % "Game-Over-Case") + break_case.to_lower().replace(" ", "-")
	var won := ("%s: " % "Won") + str(is_game_won)
	var score_txt := ("%s: " % "Score") + str(PlayerStats.inventory.victory_points.get_only_value())
	var other_stats := "[font_size=64][wave][b]%s[/b][/wave][/font_size]" % "---Other-Stats---"
	var str_stats := PlayerStats.inventory.AsString(32)
	var result : PackedStringArray = [start, end_case, won, score_txt, other_stats, str_stats]
	return "\n".join(result)


static func lose_game(break_case: String = "melt-down"):
	instance._on_game_over(false, break_case)


static func win_game(break_case: String = "conditions-are-met"):
	instance._on_game_over(true, break_case)


static func reset_game():
	PlayerStats.initialize()


func _on_again_button_pressed() -> void:
	reset_game()


func _on_menu_button_before_load() -> void:
	reset_game()
