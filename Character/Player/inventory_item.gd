extends Object
class_name InventoryItem

@export var item : Item
@export var amount : int

func _init(_item : Item, _amount : int) -> void:
	item = _item
	amount = _amount
