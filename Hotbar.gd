extends Control

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var h_box_container: HBoxContainer = $Panel/MarginContainer/HBoxContainer
var hand_equip : HandEquip
var button_group : ButtonGroup

func _ready() -> void:
	if player:
		hand_equip = player.find_child("HandEquip")
		
		var item_hotkey = 1
		button_group = ButtonGroup.new()
		
		for button in h_box_container.get_children():
			if button is ItemButton:
				button.hand_equip = hand_equip
				button.hotkey.text = str(item_hotkey)
				button.toggle_mode = true
				button.button_group = button_group			
				item_hotkey+=1
				
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var hotkey_index = 1
		for button in button_group.get_buttons():
			if event.is_action_pressed("hotkey_" + str(hotkey_index)):
				button.emit_signal("pressed")
				break
			hotkey_index+=1
