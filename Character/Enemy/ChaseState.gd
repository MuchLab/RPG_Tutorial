extends State

@export var chased_speed : float = 50
@export var acceleration : float = 25
@export var soft_collision : Area2D
@export var idle_state : State
@export var resume_state : State

var chased_character : Node2D = null

func state_process(_delta : float):
	if chased_character:
		var chased_direction = character.global_position.direction_to(chased_character.global_position)
		character.velocity = character.velocity.move_toward(chased_direction * chased_speed, acceleration)
	if soft_collision.is_colliding() and chased_character != null:
		var push_vector = soft_collision.get_push_vector()
		character.velocity += push_vector * _delta * 500

func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("fly")

func _on_player_enter_detector_body_entered(body: Node2D) -> void:
	emit_signal("interrupt_state", self)
	chased_character = body


func _on_player_detector_body_exited(body: Node2D) -> void:
	emit_signal("interrupt_state", resume_state)
	chased_character = null
	character.velocity = Vector2.ZERO
