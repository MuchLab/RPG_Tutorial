extends State

@export var run_state : State
@export var friction = 25
@export var swing_state : State
@export var roll_state : State

func state_process(_delta : float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction == Vector2.ZERO:
		character.velocity = character.velocity.move_toward(Vector2.ZERO, friction)
	else:
		animation_tree.set("parameters/idle/blend_position", direction)
		next_state = run_state
		default_direction = direction
		
func state_input(event : InputEvent):
	if event.is_action_pressed("roll"):
		next_state = roll_state
	if event.is_action_pressed("swing"):
		next_state = swing_state
		
func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("idle")
