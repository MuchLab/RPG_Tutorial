extends Area2D

signal on_hit

@export var hitting_character : CharacterBody2D
@export var effected_types : Array[DamageNodeType]

func _on_area_entered(area: Area2D) -> void:
	if area is Damageable:
		for type in area.damage_node_types:
			if type in effected_types:
				area.hit(type.create_damage_effect(), hitting_character)
