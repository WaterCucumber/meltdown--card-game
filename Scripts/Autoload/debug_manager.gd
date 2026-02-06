extends Node

enum Level {
	BRIEF,
	CLASSIC,
	SUMMARY,
	ADVANCED,
}
var lvl_to_col : Dictionary[Level, Color] = {
	Level.BRIEF : Color.DARK_KHAKI,
	Level.CLASSIC : Color.WHITE,
	Level.SUMMARY : Color.SKY_BLUE,
	Level.ADVANCED : Color.LIGHT_GOLDENROD,
}
var debug_level : Level

func _ready() -> void:
	debug_level = Level.ADVANCED


func debug(lvl: Level, args):
	if lvl <= debug_level:
		print_rich("[color=%s]" % lvl_to_col[lvl].to_html(false), args, "[/color]")
