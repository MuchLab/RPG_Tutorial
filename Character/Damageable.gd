extends Area2D

class_name Damageable

signal state_hurt_trigered(health : int, hitting_character : CharacterBody2D)
signal state_death_trigered()
signal blood_bar_changed(health : int)
signal blood_bar_initialized(health : int)
var hitting_character : CharacterBody2D = null

@export var damage_node_types : Array[DamageNodeType]
@export var health : int = 20 :
	set(new_health):
		health = new_health
		emit_signal("blood_bar_changed", health)
		if health > 0:
			emit_signal("state_hurt_trigered", health, hitting_character)
		else:
			emit_signal("state_death_trigered")
			
func _ready() -> void:
	emit_signal("blood_bar_initialized", health)
	EventBus.connect("on_monitorable_changed", _on_monitorable_changed)
	
func hit(damage_effect : DamageEffect, character : CharacterBody2D = null):
	hitting_character = character
	for method in damage_effect.get_script().get_script_method_list():
		damage_effect.call(method.name, self)

func _on_monitorable_changed(is_monitorable : bool):
	self.set_deferred("monitorable", is_monitorable)
