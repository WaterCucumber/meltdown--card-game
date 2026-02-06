extends Resource
class_name GlobalDifficulty

signal difficulty_updated(dif_factor: float)

enum Difficulty
{
	EASY,
	STANDART,
	EXTREME = 3
}

@export var const_difficulty := Difficulty.STANDART
@export var dynamic_difficulty_factor := 1.0 :
	set(v):
		if v != dynamic_difficulty_factor:
			dynamic_difficulty_factor = v


func difficulty_factor() -> float:
	var v = dynamic_difficulty_factor * 0.5 + const_difficulty_factor() * 0.5
	return v


func grow_dynamic_difficulty(add : float, factor: float, sin_pos : float = PI / 2.0):
	dynamic_difficulty_factor *= 1 + (factor - 1) * sin(sin_pos)
	dynamic_difficulty_factor += add * (sin(sin_pos) / 2.0 + 0.75)
	difficulty_updated.emit(difficulty_factor())


func get_next_factor(add : float, factor: float, sin_pos : float = PI / 2.0) -> float:
	var f : float = dynamic_difficulty_factor
	f *= 1 + (factor - 1) * sin(sin_pos)
	f += add * (sin(sin_pos) / 2.0 + 0.75)
	return f * 0.5 + const_difficulty_factor() * 0.5


func const_difficulty_factor() -> float:
	var dif_i := const_difficulty as int
	var dif_f := dif_i / 2.0 + 0.5
	return dif_f
