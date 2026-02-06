extends PanelContainer
class_name InventoryVisualizer

@onready var stats_label: RichTextLabel = $MarginContainer/VBoxContainer/Label
@onready var turn_button: Button = $MarginContainer/VBoxContainer/NextTurnButton
@onready var global_difficulty_applier: Node = $"../../../GlobalDifficultyApplier"
@onready var game_effects: ColorRect = $"../../GameEffects"


func _ready() -> void:
	PlayerStats.inventory.ValuesChanged.connect(update_stats_label)
	PlayerStats.inventory.PendingValuesChanged.connect(update_stats_label)
	turn_button.pressed.connect(PlayerStats._on_next_turn)
	turn_button.pressed.connect(_on_next_turn)
	update_stats_label()


func update_stats_label():
	var texts : Array[String] = []
	stats_label.text = ""
	for i in PlayerStats.inventory.values():
		var txt := str(i)
		#print_rich(txt)
		texts.append(txt)
	#texts.append("Difficulty: " + str(floor(global_difficulty_applier.turn_i * 1000) / 1000))
	stats_label.text = ", ".join(texts)
	var temperature := PlayerStats.get_v(CurrencyReference.Type.Temperature)
	var mat := game_effects.material as ShaderMaterial
	mat.set_shader_parameter("distort_intensity", lerpf( 
			0.001,
			0.01,
			temperature / 100.0))
	mat.set_shader_parameter("heat_distortion_strength", lerpf( 
			0,
			0.001,
			temperature / 100.0))
	mat.set_shader_parameter("heat_tint_intensity", lerpf( 
			0,
			0.25,
			temperature / 100.0))
	var radiation := PlayerStats.get_v(CurrencyReference.Type.Radiation)
	mat.set_shader_parameter("static_noise_intensity", lerpf( 
			0,
			0.25,
			radiation / 50.0))
	mat.set_shader_parameter("discolor", radiation > 25)
	#turn_button.disabled = PlayerStats.inventory.action_points.Value == 5


func _on_next_turn():
	turn_button.modulate = Color.WHITE
	#turn_button.disabled = true
