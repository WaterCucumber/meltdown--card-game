extends Node
signal value_reached_limit(currency: Currency)

const MAIN_INVENTORY = preload("uid://ca1isavrcbmqq")
const DIFFICULTY_INVENTORY = preload("uid://bk5jmou4i25sr")

var inventory: CurrencyInventory
var difficulty_inventory: CurrencyInventory


func get_v(type: CurrencyReference.Type) -> float:
	return inventory.GetCurrency(type).Value


func _ready() -> void:
	initialize()


func initialize() -> void:
	inventory = MAIN_INVENTORY.duplicate(true)
	difficulty_inventory = DIFFICULTY_INVENTORY.duplicate(true)
	inventory.set_types()
	difficulty_inventory.set_types()
	inventory.ValuesChanged.connect(on_values_changed)
	inventory.ValuesChanged.emit()


func on_values_changed():
	for i in inventory.values():
		if i is Currency:
			var type : CurrencyType = i.type
			var limit : float = type.limit
			if limit > 0:
				if is_equal_approx(i.Value, limit):
					value_reached_limit.emit(i)


func inventory_to_pending(inv : CurrencyInventory, negate := false):
	for v in inv.values():
		if not v or not v.type : continue
		var cur := inventory.GetCurrencyByType(v.type)
		if cur: cur.pending_value += v.Value * (-1) ** int(negate)


func _on_next_turn():
	inventory.safety_points.Value *= 0.5
	inventory.ApplyAllPending()
	inventory.action_points.Value = difficulty_inventory.action_points.Value
