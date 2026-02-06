extends Node
class_name Board

signal turn_started
signal turn_ended

signal card_taken(card: CardInstanceBase)
signal card_dropped()

static var instance : Board
@export var card_container: CardContainer
@onready var ui: CanvasLayer = $UI
@onready var trash_container: HBoxContainer = %TrashContainer

var selected_card : CardInstanceBase
var mouse_on_placement : CardPlacement

var card_holder : Control


func select_card(card: CardInstanceBase):
	selected_card = card
	card_taken.emit(card)


func deselect_card():
	selected_card = null
	card_dropped.emit()


func _init():
	instance = self


func _ready() -> void:
	card_holder = Control.new()
	ui.add_child(card_holder)


func _on_next_turn_button_pressed() -> void:
	for i in trash_container.get_children():
		if i is CardPlacement:
			if i.containing_card:
				PlayerStats.inventory.energy.Value += ceil(i.containing_card.card_data.cost * 0.5)
				i.containing_card.queue_free()
				i.containing_card = null
	turn_ended.emit()
	turn_started.emit()
