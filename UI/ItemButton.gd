@tool
extends Button

class_name ItemButton
#@onready var texture_rect: TextureRect = $TextureRect


@export var item : Item :
	set(item_to_slot):
		item = item_to_slot
		var texture_rect = find_child("TextureRect")
		if texture_rect:
			texture_rect.texture = item.texture

var hand_equip : HandEquip
static var last_button : Button = null
@onready var hotkey: Label = $Hotkey
@onready var panel: Panel = $Panel

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
