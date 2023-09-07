extends DamagingTool

class_name FerruginousSword

@export var min_damage : int = 3
@export var max_damage : int = 3

func _hit(area : Area2D, type : DamageNodeType):
	var damage_effect = type.create_damage_effect()
	if damage_effect is ImmediateDamageEffect:
		damage_effect.min_damage = min_damage
		damage_effect.max_damage = max_damage
		area.hit(damage_effect, character)
