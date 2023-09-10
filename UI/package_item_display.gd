extends Panel

class_name PackageItemDisplay
@onready var selected_effect: TextureRect = $SelectedEffect
@onready var texture_rect: TextureRect = $TextureRect
@onready var amount: Label = $Amount
@onready var locked_effect: TextureRect = $LockedEffect

var is_locked : bool = false
var is_hovered : bool = false
var is_selected : bool = false

func _ready() -> void:
	if not is_selected:
		selected_effect.hide()
	if not is_locked:
		locked_effect.hide()

var item_type : PackageItem :
	set(new_item):
		item_type = new_item
		if new_item:
			texture_rect.texture = new_item.texture
		else:
			texture_rect.texture = null
			amount.text = ""

func set_package_item(new_item : PackageItem, new_amount : int):
	item_type = new_item
	update_amount(new_amount)

func update_amount(new_amount : int):
	if new_amount == 1:
		amount.text = ""
	else:
		amount.text = str(new_amount)
	
func set_empty():
	texture_rect.texture = null
	
func lock():
	is_locked = true
	find_child("LockedEffect").show()
func unlock():
	is_locked = false
	find_child("LockedEffect").hide()

func set_as_hovered(_is_hovered : bool):
	is_hovered = _is_hovered

func set_as_selected(_is_selected : bool):
	is_selected = _is_selected
	if is_selected:
		selected_effect.show()
	else:
		selected_effect.hide()
