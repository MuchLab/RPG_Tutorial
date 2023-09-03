extends CanvasLayer

var window_list = []

var used_label : Control = null
var mouse_position = Vector2()

var is_draging = false
var start_drag_at = Vector2()

var viewport_size = Vector2()

func add_window(label_node : Control):
	window_list.append(label_node)
	var mouse_entered_callback = Callable(self, "on_mouse_entered").bind(label_node)
	var mouse_exited_callback = Callable(self, "on_mouse_exited").bind(label_node)
	label_node.connect("mouse_entered", mouse_entered_callback)
	label_node.connect("mouse_exited", mouse_exited_callback)
	label_node.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
func _input(event: InputEvent) -> void:
	if used_label != null and event is InputEventMouse:
		mouse_position = event.position
		viewport_size = get_viewport().get_visible_rect().size
		if is_draging:
			used_label.get_parent().set("global_position", mouse_position - start_drag_at)
			set_boundaries()

		if event is InputEventMouseButton:
			if event.is_pressed():
				if !is_draging:
					start_drag_at = mouse_position - used_label.get_parent().global_position
					is_draging = true
			else:
				if is_draging:
					is_draging = false

func on_mouse_entered(label_node : Control):
	used_label = label_node

func on_mouse_exited(label_node : Control):
	if label_node == used_label:
		used_label = null

func set_boundaries():
	var parent_node = used_label.get_parent()
	if parent_node.global_position.x < 0:
		parent_node.set("global_position", Vector2(0, parent_node.global_position.y))
	if parent_node.global_position.y < 0:
		parent_node.set("global_position", Vector2(parent_node.global_position.x, 0))
	if parent_node.size.x + parent_node.global_position.x > viewport_size.x:
		parent_node.set("global_position", Vector2(viewport_size.x - parent_node.size.x, parent_node.global_position.y))
	if parent_node.size.y + parent_node.global_position.y > viewport_size.y:
		parent_node.set("global_position", Vector2(parent_node.global_position.x, viewport_size.y - parent_node.size.y))
	return false
		
