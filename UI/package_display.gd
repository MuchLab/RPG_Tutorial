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
@onready var draging_timer: Timer = $DragingTimer

var displays : Array[PackageItemDisplay]
var inventory : Inventory = null
var hovered_item_display : PackageItemDisplay = null
var selected_item_display : PackageItemDisplay = null
var draging_texture : TextureRect = null
var is_dragging : bool = false

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
		
		#package_item.gui_input
		var package_item_gui_input_callback = Callable(self, "on_package_item_gui_input").bind(new_package_item_display)
		new_package_item_display.connect("gui_input", package_item_gui_input_callback)
		
		var on_item_mouse_entered_callback = Callable(self, "on_item_mouse_entered").bind(new_package_item_display)
		var on_item_mouse_exited_callback = Callable(self, "on_item_mouse_exited").bind(new_package_item_display)
		new_package_item_display.connect("mouse_entered", on_item_mouse_entered_callback)
		new_package_item_display.connect("mouse_exited", on_item_mouse_exited_callback)

func on_package_item_gui_input(event : InputEvent, package_item_display : PackageItemDisplay):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_dragging and event.pressed:
			if selected_item_display:
				selected_item_display.set_as_selected(false)
				selected_item_display = package_item_display
				package_item_display.set_as_selected(true)
			else:
				selected_item_display = package_item_display
				package_item_display.set_as_selected(true)
			is_dragging = true
		if is_dragging and not event.pressed:	
			if hovered_item_display:
				if hovered_item_display.item:
					if hovered_item_display != package_item_display:
						var temp_package_item = package_item_display.item.duplicate()
						var temp_amount = package_item_display.amount
						package_item_display.set_package_item(hovered_item_display.item, hovered_item_display.amount)
						hovered_item_display.set_package_item(temp_package_item, temp_amount)
						package_item_display.texture_rect.position = Vector2.ZERO
						hovered_item_display.texture_rect.position = Vector2.ZERO
					else:
						package_item_display.texture_rect.position = Vector2.ZERO
				else:
					hovered_item_display.set_package_item(package_item_display.item, package_item_display.amount)
					hovered_item_display.texture_rect.position = Vector2.ZERO
					package_item_display.set_empty()
			else:
				package_item_display.texture_rect.position = Vector2.ZERO
			draging_texture = null
			is_dragging = false
	if event is InputEventMouseMotion and is_dragging:
		draging_texture = selected_item_display.texture_rect
		draging_texture.z_index = 1
		draging_texture.position = event.position - Vector2(12, 12)
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_showed = !inventory_showed

func _on_inventory_item_amount_changed(inventory_item : InventoryItem):
	update_package_item_amount(inventory_item)

func _on_inventory_item_added(inventory_item : InventoryItem):
	add_package_item(inventory_item)

func update_package_item_amount(inventory_item : InventoryItem):
	if inventory_item.item is PackageItem:
		var current_display : PackageItemDisplay
		for display in displays:
			if display.item == inventory_item.item:
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

func find_available_space(item : PackageItem) -> PackageItemDisplay:
	for package_item_display in grid_container.get_children():
		if !package_item_display.is_locked:
			if package_item_display.item == null:
				return package_item_display
	return null


func on_item_mouse_entered(item):
	if item != hovered_item_display and not item.is_locked:
		hovered_item_display = item
		hovered_item_display.set_as_hovered(true)
	
func on_item_mouse_exited(item):
	if hovered_item_display != null:
		hovered_item_display.set_as_hovered(false)
		hovered_item_display = null
		item.is_hovered = false


func _on_close_pressed() -> void:
	inventory_showed = false
