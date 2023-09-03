extends Panel

const CLR_NORMAL = "white"
const CLR_YELLOW = "yellow"
const CLR_MINE = "gray"
const CLR_TITLE = "purple"

var chat_active : bool = false
@export var chat_showed : bool = false
@onready var memo: RichTextLabel = $Memo

func _input(event: InputEvent) -> void:
#	$MarginContainer.set_deferred("theme_override_constants/margin_top", $Title.get_minimum_size().y)
#	$MarginContainer.set_deferred("theme_override_constants/margin_bottom", $Input.get_minimum_size().y)
	if event.is_action_pressed("chat"):
		chat_showed = !chat_showed
	if event.is_action_pressed("ui_accept"):
		if !chat_active:
			focus_on()
	else:
		if chat_active and !$Input.has_focus():
			chat_active = false
		
func _ready() -> void:
	$Input.set_text("")
	add_text_to_chat(CLR_TITLE, "Welcome to the RPG Tutorial!")
	add_text_to_chat(CLR_YELLOW, "Welcome to the RPG Tutorial!", "Muchlab")
	get_parent().add_window($Title)

func _process(delta: float) -> void:
	if chat_showed:
		self.show()
	else:
		self.hide()
		
func focus_on():
	chat_active = true
	$Input.grab_focus()

func add_text_to_chat(clr, txt, sent_by = ""):
	if sent_by == "":
		memo.set_text(memo.text + "\n" + "[color=" + clr + "]" + txt + "[/color]")
	else:
		memo.append_text("\n" + "[color=" + CLR_NORMAL + "](" + sent_by + ")[/color]" + "[color=" + clr + "]" + txt + "[/color]")
	memo.scroll_to_line(memo.get_line_count() - 1)

func Input_to_chat():
	var msg : String = $Input.text
	msg = msg.replace("\n", "")
	var _msg = msg.replace(" ", "")
	if _msg.length() == 0:
		return
	if !msg.is_empty():
		add_text_to_chat(CLR_MINE, msg, CharacterDb.Nickname)
		$Input.clear()
		$Input.release_focus()

func _on_input_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("send_msg"):
		Input_to_chat()

