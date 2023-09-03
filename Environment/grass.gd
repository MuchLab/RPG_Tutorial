extends Node2D

var grass_effect_template = preload("res://Effect/grass_effect.tscn")

func create_grass_effect():
	var grass_effect = grass_effect_template.instantiate()
	var curren_scene = get_tree().current_scene
	curren_scene.add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_hurtbox_on_hurt(_damage, _hitting_character) -> void:
	create_grass_effect()
	queue_free()
