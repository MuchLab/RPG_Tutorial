extends State

@export var idle_state : State
@export var max_speed : float = 150
@export var acceleration : float = 50

func state_process(_delta : float):
	animation_tree.set("parameters/roll/blend_position", default_direction)
	character.velocity = character.velocity.move_toward(default_direction * max_speed, acceleration)
	

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	character.velocity = Vector2.ZERO
	if anim_name.contains("roll"):
		next_state = idle_state

func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("roll")
