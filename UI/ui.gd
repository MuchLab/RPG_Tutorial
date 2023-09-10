extends CanvasLayer

var used_label : Control = null
var used_window : Control = null
var mouse_position = Vector2()

var is_draging = false
var start_drag_at = Vector2()

var viewport_size = Vector2()

func add_window(label_node : Control, window_node : Control):
	var mouse_entered_callback = Callable(self, "on_mouse_entered").bind(label_node, window_node)
	var mouse_exited_callback = Callable(self, "on_mouse_exited").bind(label_node, window_node)
	label_node.connect("mouse_entered", mouse_entered_callback)
	label_node.connect("mouse_exited", mouse_exited_callback)
	label_node.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
func _input(event: InputEvent) -> void:
	if used_label != null and event is InputEventMouse:
		mouse_position = event.position
		viewport_size = get_viewport().get_visible_rect().size
		if is_draging:
			used_window.set("global_position", mouse_position - start_drag_at)
			set_boundaries()

		if event is InputEventMouseButton:
			if event.is_pressed():
				if !is_draging:
					start_drag_at = mouse_position - used_window.global_position
					is_draging = true
			else:
				if is_draging:
					is_draging = false

func on_mouse_entered(label_node : Control, window_node : Control):
	used_label = label_node
	used_window = window_node
	

func on_mouse_exited(label_node : Control, window_node : Control):
	if label_node == used_label and window_node == used_window:
		used_label = null
		used_window = null

func set_boundaries():
	if used_window.global_position.x < 0:
		used_window.set("global_position", Vector2(0, used_window.global_position.y))
	if used_window.global_position.y < 0:
		used_window.set("global_position", Vector2(used_window.global_position.x, 0))
	if used_window.size.x + used_window.global_position.x > viewport_size.x:
		used_window.set("global_position", Vector2(viewport_size.x - used_window.size.x, used_window.global_position.y))
	if used_window.size.y + used_window.global_position.y > viewport_size.y:
		used_window.set("global_position", Vector2(used_window.global_position.x, viewport_size.y - used_window.size.y))
	return false
		
