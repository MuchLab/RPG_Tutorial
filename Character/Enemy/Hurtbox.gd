extends Area2D

#signal invincible_started
#signal invincible_ended
#@onready var collision_shape: CollisionShape2D = $CollisionShape2D
#@onready var timer: Timer = $Timer
#@export var character : CharacterBody2D
#
#var hit_effect_template = preload("res://Effect/hit_effect.tscn")
#var invincible : bool  = false :
#	set = set_invicible
#
#func set_invicible(value):
#	invincible = value
#	if invincible:
#		emit_signal("invincible_started")
#	else:
#		emit_signal("invincible_ended")
#
#func start_invincibility():
#	self.invincible = true
#	timer.start()
#
#func create_hit_effect():
#	var hit_effect = hit_effect_template.instantiate()
#	var main_scene = get_tree().current_scene
#	main_scene.add_child(hit_effect)
#	hit_effect.global_position = character.global_position
#
#
#func _on_timer_timeout() -> void:
#	self.invincible = false
#
#func _on_invincible_ended() -> void:
#	collision_shape.disabled = false
#
#
#func _on_invincible_started() -> void:
#	collision_shape.set_deferred("disabled", true)

signal on_hurt(damage : int, hitting_character : CharacterBody2D)


