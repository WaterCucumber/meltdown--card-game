extends Panel
class_name TransitionBase

signal transition_step(percent: float)
signal reversed_transition_step(percent: float)

signal any_transition_started

signal transition_ended(id: int)
signal reversed_transition_ended()

signal any_transition_ended

var transiting: bool = false
var use_visible = true
var speed_coef := 1.5

func transition(id: int = 0, speed := 1.0) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if use_visible: visible = true
	
	any_transition_started.emit()
	
	transiting = true
	
	var percent: float = 0
	speed *= speed_coef  # Увеличьте или уменьшите скорость затемнения

	# Задержка для начала анимации
	await get_tree().create_timer(0.01).timeout

	while percent < 1:
		var delta_add: float = get_process_delta_time() * speed
		percent += delta_add
		_transit_step(percent)
		_any_transition_step(percent)
		transition_step.emit(percent)
		if not is_inside_tree():
			return
		await get_tree().create_timer(0.01).timeout
	
	if use_visible: transiting = false
	
	transition_ended.emit(id)
	any_transition_ended.emit()
	
	#visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func reversed_transition(speed := 1.0) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if use_visible: visible = true
	
	any_transition_started.emit()
	
	transiting = true
	
	var percent: float = 1
	speed *= speed_coef  # Увеличьте или уменьшите скорость затемнения

	# Задержка для начала анимации
	await get_tree().create_timer(0.01).timeout

	while percent > 0:
		var delta_add: float = get_process_delta_time() * speed
		percent -= delta_add
		_reversed_transit_step(percent)
		_any_transition_step(percent)
		reversed_transition_step.emit(percent)
		if not is_inside_tree(): break
		await get_tree().create_timer(0.01).timeout  # Задержка для плавности анимации
	
	transiting = false
	
	reversed_transition_ended.emit()
	any_transition_ended.emit()
	
	if use_visible: visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _any_transition_step(_percent: float):
	pass


func _transit_step(_percent: float):
	pass


func _reversed_transit_step(_percent: float):
	pass
