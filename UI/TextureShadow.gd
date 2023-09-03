extends TextureRect

signal on_mouse_left_release

func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		emit_signal("on_mouse_left_release")

func _ready() -> void:
	self.set_mouse_filter(Control.MOUSE_FILTER_PASS)
