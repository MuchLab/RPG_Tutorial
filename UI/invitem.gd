extends Control

@export var unlocked_clr = Color(1,1,1,1)
@export var locked_clr = Color(1,0.3,0.3,1)
@export var drag_clr = Color(1,1,1,0)
@export var selected_clr = Color(0,1,0,1)
@export var hovered_clr : Color = Color.YELLOW
@export var normal_clr : Color
var is_selected = false
var is_hovered = false
var is_locked = false

var current_item = null : 
	set = set_current_item
@onready var texture_rect: TextureRect = $Panel/TextureRect
@onready var panel: Panel = $Panel
@onready var amount: Label = $Panel/Amount

func set_current_item(item):
	current_item = item
	if item != null:
		get_node("Panel/TextureRect").texture = JSONItemDb.smart_texture_load(item)
		get_node("Panel/Amount").text = str(item["amount"])
	
func is_empty():
	return $Panel/Amount.text == ""
	
func set_empty_item():
	$Panel/Amount.text = ""

func lock_item():
	is_locked = true
	$Panel.modulate = locked_clr
	
func unlock_item():
	is_locked = false
	$Panel.modulate = unlocked_clr

func set_as_drag(item_id):
	current_item = item_id
	texture_rect.texture = JSONItemDb.smart_texture_load(item_id)
	$Panel.modulate = drag_clr
	sync_amount()


func subtract_item(amount):
	if amount > 0:
		current_item["amount"] -= amount
		if current_item["amount"] > 0:
			sync_amount()
		else:
			current_item = null
			texture_rect.texture = null
			$Panel/Amount.visible = false
		
func set_as_selected(_is_selected : bool):
	is_selected = _is_selected
	if _is_selected:
		$Panel.modulate = selected_clr
	else:
		$Panel.modulate = unlocked_clr
		
func set_as_hovered(_is_hovered : bool):
	is_hovered = _is_hovered
	if !is_selected:
		if _is_hovered:
			$Panel.modulate = hovered_clr
		else:
			$Panel.modulate = unlocked_clr
	else:
		$Panel.modulate = selected_clr
		
func sync_amount():
	$Panel/Amount.text = str(current_item["amount"])
	if current_item["amount"] == 1:
		$Panel/Amount.visible = false
	else:
		$Panel/Amount.visible = true

func add_item(item_id):
	if current_item != null:
		current_item["amount"] += item_id["amount"]
		sync_amount()
	else:
		current_item = item_id
		texture_rect.texture = JSONItemDb.smart_texture_load(item_id)
		sync_amount()
