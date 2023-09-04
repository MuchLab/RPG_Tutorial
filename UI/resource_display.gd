extends GridContainer

@export var item_display_template : PackedScene
@onready var display_container: MarginContainer = $DisplayContainer

var displays : Array[ResourceItemDisplay]
var player_inventory : Inventory

func _ready() -> void:
	var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
	player_inventory = player.find_child("Inventory") as Inventory
	player_inventory.connect("resource_count_changed", _on_player_inventory_resource_count_changed)

func _on_player_inventory_resource_count_changed(type : ResourceItem, new_count : int) -> void:
	var current_display : ResourceItemDisplay
	
	for display in displays:
		if display.resource_type == type:
			current_display = display
			current_display.update_count(new_count)
			break
			
	if current_display == null:
		var new_display : ResourceItemDisplay = item_display_template.instantiate() as ResourceItemDisplay
		display_container.add_child(new_display)
		new_display.resource_type = type
		new_display.update_count(new_count)
		displays.append(new_display)
