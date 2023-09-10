extends MarginContainer

@export var item_display_template : PackedScene

var displays : Array[ResourceItemDisplay]
var player_inventory : Inventory
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
	player_inventory = player.find_child("Inventory") as Inventory
	player_inventory.connect("inventory_item_added_to_resource_display", _on_inventory_item_added)
	player_inventory.connect("inventory_item_amount_changed_to_resource_display", _on_player_inventory_item_amount_changed)

func _on_player_inventory_item_amount_changed(inventory_item : InventoryItem) -> void:
	var current_display : ResourceItemDisplay
	if inventory_item.item is ResourceItem:
		for display in displays:
			if display.resource_type == inventory_item.item:
				current_display = display
				current_display.update_count(inventory_item.amount)
				break
	if current_display == null:
		add_inventory_item(inventory_item)
		
func _on_inventory_item_added(inventory_item : InventoryItem):
	add_inventory_item(inventory_item)
	
func add_inventory_item(inventory_item : InventoryItem):
	if inventory_item.item is ResourceItem:
		var new_display : ResourceItemDisplay = item_display_template.instantiate() as ResourceItemDisplay
		grid_container.add_child(new_display)
		new_display.resource_type = inventory_item.item
		new_display.update_count(inventory_item.amount)
		displays.append(new_display)
