extends Button
class_name LoadSceneButton

signal before_load

@export_file(".tscn") var scene_to_load : String
@export var transition: TransitionBase

func _ready() -> void:
	transition.transition_ended.connect(_on_transition_ended)


func _pressed() -> void:
	if scene_to_load.is_empty():
		push_warning("Scene not selected! Button: ", name)
		return
	transition.transition(5)
	LoadingScreenManager.next_scene = scene_to_load


func _on_transition_ended(id: int):
	if id != 5: return
	before_load.emit()
	LoadingScreenManager.get_tree().change_scene_to_packed(LoadingScreenManager.loading_screen)
