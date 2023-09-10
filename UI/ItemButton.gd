@tool
extends Button

class_name HotbarItemButton
#@onready var texture_rect: TextureRect = $TextureRect


@export var item : Item :
	set(item_to_slot):
		item = item_to_slot
		var texture_rect = find_child("TextureRect")
		if texture_rect:
			texture_rect.texture = item.texture

var hand_equip : HandEquip
static var last_button : Button = null
@export var hotkey: Label
@onready var amount: Label = $Amount
@onready var panel: Panel = $Panel

func set_hotbar_item_button(new_item : Item, new_amount : int, new_hand_equip : HandEquip):
	item = new_item
	hand_equip = new_hand_equip
	update_amount(new_amount)
func update_amount(new_amount : int):
	if new_amount == 1:
		amount.text = ""
	else:
		amount.text = str(new_amount)

func _ready() -> void:
	if not Engine.is_editor_hint():
		panel.visible = false
		connect("pressed", _on_pressed)
	
func _on_pressed():
	if not Engine.is_editor_hint():
		if item is EquippableItem:
			if hand_equip != null:
				hand_equip.equipped_item = item
				panel.visible = true
				if last_button and last_button != self:
					last_button.panel.visible = false
				
				last_button = self
