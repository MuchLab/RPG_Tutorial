extends PanelContainer

const ITEM_STACKABLE = "stackable"
const ITEM_NAME = "name"
const ITEM_AMOUNT = "amount"
const package_item_template = preload("res://UI/package_item_display.tscn")

@export var max_package_space = 60
@export var inventory_showed = false
@onready var grid_container: GridContainer = $VBoxContainer/MarginContainer/ScrollContainer/GridContainer
@onready var split_box: Panel = $"../SplitBox"
@onready var title: Label = $VBoxContainer/Title

var displays : Array[PackageItemDisplay]
var inventory : Inventory = null
var hovered_item = null
var selected_item = null
var splited_item = null

func _process(delta: float) -> void:
	if inventory_showed:
		self.show()
	else:
		self.hide()

func _ready() -> void:
	get_parent().add_window(title, self)
	var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
	inventory = player.find_child("Inventory") as Inventory
	inventory.connect("inventory_item_amount_changed_to_package_display", _on_inventory_item_amount_changed)
	inventory.connect("inventory_item_added_to_package_display", _on_inventory_item_added)
	var package_item : PackageItemDisplay = package_item_template.instantiate()
	for x in range(max_package_space):
		var new_package_item_display = package_item.duplicate()
		if x >= CharacterDb.available_inv_space:
			new_package_item_display.lock()
		grid_container.add_child(new_package_item_display)
		displays.append(new_package_item_display)
		var on_item_mouse_entered_callback = Callable(self, "on_item_mouse_entered").bind(new_package_item_display)
		var on_item_mouse_exited_callback = Callable(self, "on_item_mouse_exited").bind(new_package_item_display)
		new_package_item_display.connect("mouse_entered", on_item_mouse_entered_callback)
		new_package_item_display.connect("mouse_exited", on_item_mouse_exited_callback)
func _on_inventory_item_amount_changed(inventory_item : InventoryItem):
	update_package_item_amount(inventory_item)

func _on_inventory_item_added(inventory_item : InventoryItem):
	add_package_item(inventory_item)

func update_package_item_amount(inventory_item : InventoryItem):
	if inventory_item.item is PackageItem:
		var current_display : PackageItemDisplay
		for display in displays:
			if display.item_type == inventory_item.item:
				current_display = display
				current_display.update_amount(inventory_item.amount)
				break
		if current_display == null:
			add_package_item(inventory_item)

func add_package_item(inventory_item):
	if inventory_item.item is PackageItem:
		var available_space = find_available_space(inventory_item.item)
		if available_space:
			available_space.set_package_item(inventory_item.item, inventory_item.amount)
		else:
			print_debug("There is no space for " + inventory.item.display_name)

func find_available_space(item_type : PackageItem) -> PackageItemDisplay:
	for package_item_display in grid_container.get_children():
		if !package_item_display.is_locked:
			if package_item_display.item_type == null:
				return package_item_display
	return null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_showed = !inventory_showed
	if hovered_item != null and splited_item == null and event.is_action_pressed("mouse_left"):
		if selected_item == null:
			if not hovered_item.is_empty():
				selected_item = hovered_item
				selected_item.set_as_selected(true)
		elif hovered_item != selected_item:
			split_box.hide()
			exchange_item(selected_item, hovered_item)
			selected_item.set_as_selected(false)
			selected_item = null
		else:
			split_box.hide()
			selected_item.set_as_selected(false)
			selected_item = null
	if (hovered_item != null and 
		selected_item != null and 
		splited_item != null and 
		event.is_action_pressed("mouse_left")):
			hovered_item.current_item = splited_item.current_item
			selected_item.subtract_item(splited_item.current_item[ITEM_AMOUNT])
			selected_item.set_as_selected(false)
			selected_item = null
			splited_item = null
			split_box.hide()
		
	if selected_item != null and event.is_action_pressed("split"):
		split_box.show()
		split_box.init_split_box(selected_item)
		
func get_item_index(item):
	var index = 0
	for child in grid_container.get_children():
		if item == child or index == CharacterDb.available_inv_space - 1:
			break
		index += 1
	return index

func exchange_item(from, to):
	var from_index = get_item_index(from)
	var to_index = get_item_index(to)
	grid_container.move_child(from, to_index)
	grid_container.move_child(to, from_index)
	print("from: " + str(from_index))
	print("to: " + str(to_index))

func on_item_mouse_entered(item):
	if item != hovered_item and not item.is_locked:
		hovered_item = item
		hovered_item.set_as_hovered(true)
	
func on_item_mouse_exited(item):
	if hovered_item != null:
		hovered_item.set_as_hovered(false)
		hovered_item = null
		item.is_hovered = false

func _on_split_box_item_splited(split_amount) -> void:
	splited_item = package_item_template.instantiate()
	splited_item.current_item = selected_item.current_item.duplicate()
	splited_item.current_item[ITEM_AMOUNT] = split_amount


func _on_close_pressed() -> void:
	inventory_showed = false
