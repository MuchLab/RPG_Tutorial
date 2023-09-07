extends State

@export var player_death_animation : AnimatedSprite2D
#@export var sprite : Sprite2D

func on_enter():
	character.sprite.hide()
	player_death_animation.show()
	player_death_animation.play("default")



func _on_damageable_state_death_trigered() -> void:
	emit_signal("interrupt_state", self)
