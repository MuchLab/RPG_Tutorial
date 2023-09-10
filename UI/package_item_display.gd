extends Panel

class_name PackageItemDisplay

@onready var texture_rect: TextureRect = $TextureRect
@onready var amount: Label = $Amount

const locked_color = Color.YELLOW
var is_locked : bool
var is_hovered : bool = false

func _ready() -> void:
	pass

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
	self.modulate = locked_color

func set_as_hovered(_is_hovered : bool):
	is_hovered = _is_hovered
