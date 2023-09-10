extends Resource

class_name Item

@export var display_name : String
@export var texture : Texture2D
@export var stackable : bool = false

static func is_type_matched(a_item : Item, b_item : Item) -> bool:
	return (a_item.get_class() == b_item.get_class() and 
	a_item.get_script() == b_item.get_script())
