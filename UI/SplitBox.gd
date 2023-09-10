extends Panel

signal item_splited(split_amount : int)

const ITEM_NAME = "name"
const ITEM_AMOUNT = "amount"
@onready var inv_name: Label = $InvName
@onready var h_slider: HSlider = $HSlider
@onready var line_edit: LineEdit = $LineEdit

func _ready() -> void:
	get_parent().add_window($Title, self)
	line_edit.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	
func init_split_box(item_ui):
	pass

func _on_h_slider_value_changed(value: float) -> void:
	line_edit.text = str(value)


func _on_line_edit_text_changed(new_text: String) -> void:
	h_slider.value = int(line_edit.text)


func _on_close_button_pressed() -> void:
	self.hide()


func _on_split_button_pressed() -> void:
	if h_slider.value > 0:
		emit_signal("item_splited", h_slider.value)
