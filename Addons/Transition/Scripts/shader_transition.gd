class_name ShaderTransition
extends TransitionBase

const NOISES : Array[Texture2D] = [
	preload("res://Addons/Transition/Sprites/Noises/Cracks 8 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Craters 7 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Grainy 1 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Grainy 8 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Manifold 12 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Marble 13 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Melt 2 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Milky 1 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Perlin 23 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Streak 4 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Super Noise 1 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Super Perlin 14 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Swirl 6 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Techno 12 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Turbulence 1 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Turbulence 3 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Turbulence 14 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Vein 12 - 512x512.png"),
	preload("res://Addons/Transition/Sprites/Noises/Voronoi 13 - 512x512.png")
]

static var current_noise: Texture2D = NOISES[0]
static var current_noise_index: int

@export var start_transition: bool = true
@export var change_noise_scene: bool = false

var shader_material: ShaderMaterial

func _ready() -> void:
	if material is ShaderMaterial:
		shader_material = material
	else:
		material = load("res://Addons/Transition/Shaders/transition.tres")
		shader_material = material

	if start_transition:
		change_noise()
		reversed_transition()


func _any_transition_step(percent: float):
	shader_material.set_shader_parameter("progress", 1-percent)
	material = shader_material


func change_noise():
	if change_noise_scene:
		current_noise_index = randi_range(0, NOISES.size() - 1)
		current_noise = NOISES[current_noise_index]

	shader_material.set_shader_parameter("noise_tex", current_noise)
