extends Control

@onready var top_progress_bar: TextureProgressBar = %TopProgressBar
@onready var bottom_progress_bar: TextureProgressBar = %BottomProgressBar
@onready var progress_label: RichTextLabel = %ProgressLabel
@onready var transition: ShaderTransition = $Transition

var packed_scene : PackedScene

func _ready():
	await transition.reversed_transition_ended
	ResourceLoader.load_threaded_request(LoadingScreenManager.next_scene)
	transition.transition_ended.connect(transition_ended)


func _process(_delta: float) -> void:
	var progress : Array = []
	ResourceLoader.load_threaded_get_status(LoadingScreenManager.next_scene, progress)
	top_progress_bar.value = progress[0]
	bottom_progress_bar.value = progress[0]
	var str_progress := str(floorf(progress[0] * 10000) / 100)
	progress_label.text = "[color=red][font_size=32]%s" % str_progress + "%/100%"

	if is_equal_approx(progress[0], 1):
		loading_ended()


func transition_ended(id: int):
	if id == 5:
		get_tree().change_scene_to_packed(packed_scene)


func loading_ended():
	set_process(false)
	top_progress_bar.value = 1
	bottom_progress_bar.value = 1
	progress_label.text = "[color=red][font_size=32]Ended"
	packed_scene = ResourceLoader.load_threaded_get(LoadingScreenManager.next_scene)
	transition.transition(5)
