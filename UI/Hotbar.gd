extends Panel

@onready var h_box_container: HBoxContainer = $VBoxContainer/Panel/MarginContainer/HBoxContainer
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var title: Label = $VBoxContainer/Title

const hotbar_item_button_template = preload("res://UI/item_button.tscn")
@export var max_hotbar_space : int = 5
var hand_equip : HandEquip
var button_group : ButtonGroup
var inventory : Inventory

func _ready() -> void:
	get_parent().add_window(title, self)
	if player:
		inventory = player.find_child("Inventory")
		inventory.connect("inventory_item_amount_changed_to_hotbar", _on_inventory_item_amount_changed)
		inventory.connect("inventory_item_added_to_hotbar", _on_inventory_item_added)
		hand_equip = player.find_child("HandEquip")
	var item_hotkey = 1
	button_group = ButtonGroup.new()
	for i in range(max_hotbar_space):
		var new_button = hotbar_item_button_template.instantiate()
		new_button.hotkey.text = str(item_hotkey)
		new_button.toggle_mode = true
		new_button.button_group = button_group
		h_box_container.add_child(new_button)
		item_hotkey+=1
		
#	if player:
#		hand_equip = player.find_child("HandEquip")
#
#		var item_hotkey = 1
#		button_group = ButtonGroup.new()
#
#		for button in h_box_container.get_children():
#			if button is HotbarItemButton:
#				button.hand_equip = hand_equip
#				button.hotkey.text = str(item_hotkey)
#				button.toggle_mode = true
#				button.button_group = button_group			
#				item_hotkey+=1
	
				
func _on_inventory_item_amount_changed(inventory_item:InventoryItem):
	update_hotbar_item_amount(inventory_item)
	
func _on_inventory_item_added(inventory_item:InventoryItem):
	add_hotbar_item(inventory_item)

func update_hotbar_item_amount(inventory_item : InventoryItem):
	var current_button : HotbarItemButton
	for button in button_group.get_buttons():
		if button.item == inventory_item.item:
			current_button = button
			current_button.update_amount(inventory_item.amount)
	if current_button == null:
		add_hotbar_item(inventory_item)

func find_available_space(item_type : PackageItem) -> HotbarItemButton:
	for hotbar_item_button in h_box_container.get_children():
		if hotbar_item_button.item == null:
			return hotbar_item_button
	return null

func add_hotbar_item(inventory_item:InventoryItem):
	var item = inventory_item.item
	if item is PackageItem:
		if item.is_hotbar:
			var available_space = find_available_space(item)
			if available_space:
				available_space.set_hotbar_item_button(item, inventory_item.amount, hand_equip)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var hotkey_index = 1
		for button in button_group.get_buttons():
			if event.is_action_pressed("hotkey_" + str(hotkey_index)):
				button.emit_signal("pressed")
				break
			hotkey_index+=1
