extends PlaceableCardUse
class_name AddDataCardUse

@export var data: Array[CurrencyReference]


func _on_placed():
	var inv = PlayerStats.inventory
	for i in data:
		inv.AddPending(i.type, i.value)


func _on_removed():
	var inv = PlayerStats.inventory
	for i in data:
		inv.AddPending(i.type, -i.value)
