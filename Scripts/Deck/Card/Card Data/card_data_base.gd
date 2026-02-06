@abstract extends Resource
class_name CardDataBase

## Chances: 8:8:5:4 -> 1,0.68,0.36,0.16 (0.32,0.32,0.2,0.16)
enum CardType {
	NONE,
	STAFF,
	EQUIPMENT,
	EVENT,
	CRISES,
}

const type_to_color : Dictionary[CardType, Color] = {
	CardType.NONE : Color.DEEP_PINK,
	CardType.STAFF : Color(0.282, 0.184, 0.0),
	CardType.EQUIPMENT : Color(0.516, 0.516, 0.516),
	CardType.EVENT : Color(0.435, 0.438, 0.096, 1.0),
	CardType.CRISES : Color(0.235, 0.0, 0.367),
}

@export_multiline var description := ""
@export var cost := 0

@export var texture : Texture2D
@export var effect_texture : Texture2D

@abstract func get_type() -> CardType

var _cashed_name := ""
var cashed_name := "" :
	get():
		if _cashed_name == "":
			return get_card_name()
		return _cashed_name

func get_card_name() -> String:
	if _cashed_name != "": return _cashed_name
	var postfix = "_name"
	var res_name = resource_path.split("/")[-1]
	res_name = res_name.replace(".tres", "")
	if _cashed_name == "":
		_cashed_name = tr(res_name + postfix)
	return tr(res_name + postfix)
