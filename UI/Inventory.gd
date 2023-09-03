extends Panel

const ITEM_STACKABLE = "stackable"
const ITEM_NAME = "name"
const ITEM_AMOUNT = "amount"
const inv_item_template = preload("res://UI/invitem.tscn")

@export var max_inv_space = 60
@export var inventory_showed = false
@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var chat_ui: Panel = $"../Chat"
@onready var menu_bar: MenuBar = $MenuBar
@onready var split_box: Panel = $"../SplitBox"

var hovered_item = null
var selected_item = null
var splited_item = null

func _process(delta: float) -> void:
	if inventory_showed:
		self.show()
	else:
		self.hide()
	

func _ready() -> void:
	var inv_item = inv_item_template.instantiate()
	get_parent().add_window($Title)
	for x in range(max_inv_space):
		var new_inv_item = inv_item.duplicate()
		new_inv_item.set_empty_item()
		if x >= CharacterDb.available_inv_space:
			new_inv_item.lock_item()
		grid_container.add_child(new_inv_item)
		
		var on_item_mouse_entered_callback = Callable(self, "on_item_mouse_entered").bind(new_inv_item)
		var on_item_mouse_exited_callback = Callable(self, "on_item_mouse_exited").bind(new_inv_item)
		new_inv_item.panel.connect("mouse_entered", on_item_mouse_entered_callback)
		new_inv_item.panel.connect("mouse_exited", on_item_mouse_exited_callback)

	add_item_from_db("Glove", 10)
	add_item_from_db("Helmet", 10)

func find_free_inv_item_or_stack(item_name):
	for x in grid_container.get_children():
		if !x.is_locked:
			if x.current_item == null:
				return x
			else:
				if x.current_item[ITEM_STACKABLE] and x.current_item[ITEM_NAME] == item_name:
					return x

func  add_item_to_free_space(item, item_name):
	var free_inv_space = find_free_inv_item_or_stack(item[ITEM_NAME])
	if free_inv_space == null:
		chat_ui.add_text_to_chat(chat_ui.CHAT_YELLOW, "There is no space for " + item_name)
	else:
		free_inv_space.add_item(item)
		
func add_item_from_db(item_name, amount):
	var item = JSONItemDb.get_item_by_id(item_name)
	if item[ITEM_STACKABLE]:
		item[ITEM_AMOUNT] = amount
		add_item_to_free_space(item, item_name)
	else:
		for x in range(amount):
			item[ITEM_AMOUNT] = 1
			add_item_to_free_space(item, item_name)

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
			
	if hovered_item != null and event.is_action_pressed("mouse_right"):
		var popup_menu = preload("res://UI/inv_popup_menu.tscn").instantiate()
		popup_menu.global_position = event.global_position
#		grid_container.add_child(popup_menu)
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
	splited_item = inv_item_template.instantiate()
	splited_item.current_item = selected_item.current_item.duplicate()
	splited_item.current_item[ITEM_AMOUNT] = split_amount


func _on_close_pressed() -> void:
	inventory_showed = false
