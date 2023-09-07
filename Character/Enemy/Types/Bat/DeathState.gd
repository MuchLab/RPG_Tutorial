extends State

@export var hit_box : Area2D

func on_enter():
	hit_box.monitoring = false
	character.sprite.hide()
	character.death_effect.show()
	animation_tree[PLAYBACK_PARAMETER_STR].travel("death")
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		character.queue_free()


func _on_damageable_state_death_trigered() -> void:
	emit_signal("interrupt_state", self)
