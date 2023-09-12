extends Control

class_name Inventory

signal inventory_item_amount_changed_to_resource_display(inventory_item : InventoryItem)
signal inventory_item_added_to_resource_display(inventory_item : InventoryItem)
signal inventory_item_amount_changed_to_package_display(inventory_item : InventoryItem)
signal inventory_item_added_to_package_display(inventory_item : InventoryItem)
signal inventory_item_amount_changed_to_hotbar(inventory_item : InventoryItem)
signal inventory_item_added_to_hotbar(inventory_item : InventoryItem)

@export var inventory_items : Dictionary = {}
static var current_item_id = 0



func _ready() -> void:
#	var resource_loader = ResourceLoader.add_resource_format_loader()
	await get_tree().current_scene.find_child("UI").ready
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/DamagingTool/ferruginous_sword.tres"), 1)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/HarvestingTool/ferruginous_axe.tres"), 1)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/HarvestingTool/ferruginous_pickaxe.tres"), 1)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/HarvestingTool/ferruginous_hammer.tres"), 1)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/DefendingTool/ferruginous_glove.tres"), 3)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/DefendingTool/ferruginous_glove.tres"), 1)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/DefendingTool/ferruginous_helmet.tres"), 10)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/DefendingTool/ferruginous_helmet.tres"), 10)
	add_inventory_item(ResourceLoader.load("res://Items/PackageItem/EquipableItem/DefendingTool/ferruginous_helmet.tres"), 10)

func update_item_id():
	var max_id = current_item_id
	for id in inventory_items.keys():
		if id > max_id:
			max_id = id
			
	current_item_id = max_id

func has_item_type(item : Item) -> int:
	for id in inventory_items.keys():
		var inventory_item = inventory_items[id]
		if Item.is_type_matched(item, inventory_item.item):
			return id
	return -1
	
func add_inventory_item(item : Item, amount : int):
	if item.stackable:
		for i in range(amount):
			var inventory_item = InventoryItem.new(item, 1)
			inventory_items[current_item_id] = inventory_item
			current_item_id+=1
			
			if item is ResourceItem:
				emit_signal("inventory_item_added_to_resource_display", inventory_item)
			elif item is PackageItem:
				if item.is_hotbar:
					emit_signal("inventory_item_added_to_hotbar", inventory_item)
				else:
					emit_signal("inventory_item_added_to_package_display", inventory_item)
	else:
		var id = has_item_type(item)
		if id != -1:
			inventory_items[id].amount+=amount
			if item is ResourceItem:
				emit_signal("inventory_item_amount_changed_to_resource_display", inventory_items[id])
			elif item is PackageItem:
				if item.is_hotbar:
					emit_signal("inventory_item_amount_changed_to_hotbar", inventory_items[id])
				else:
					emit_signal("inventory_item_amount_changed_to_package_display", inventory_items[id])
		else:
			var inventory_item = InventoryItem.new(item, amount)
			inventory_items[current_item_id] = inventory_item
			current_item_id+=1
			
			if item is ResourceItem:
				emit_signal("inventory_item_added_to_resource_display", inventory_item)
			elif item is PackageItem:
				if item.is_hotbar:
					emit_signal("inventory_item_added_to_hotbar", inventory_item)
				else:
					emit_signal("inventory_item_added_to_package_display", inventory_item)
#		print("Inventory:")
#		for id in inventory_items.keys():
#		var inventory_item = inventory_items[id]
#		print("name: " + inventory_item.item.display_name + ", amount: " + str(inventory_item.amount))
