extends State

@export var idle_state : State
@export var run_state : State
@onready var run_request_timer: Timer = $RunRequestTimer

func state_input(_event : InputEvent):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO and run_request_timer.is_stopped():
		next_state = run_state

func on_enter():
	animation_tree.set("parameters/swing/blend_position", default_direction)
	animation_tree[PLAYBACK_PARAMETER_STR].travel("swing")
	run_request_timer.start()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("swing"):
		next_state = idle_state

