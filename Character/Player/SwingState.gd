extends State

@export var idle_state : State
@export var run_state : State

func state_input(_event : InputEvent):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		next_state = run_state

func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("attack")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		next_state = idle_state

