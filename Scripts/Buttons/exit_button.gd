extends Button
class_name ExitButton

@export var transition : TransitionBase

func _ready() -> void:
	transition.transition_ended.connect(_on_transition_ended)


func _pressed() -> void:
	transition.transition(-1)


func _on_transition_ended(id: int):
	if id != -1: return
	get_tree().quit()
