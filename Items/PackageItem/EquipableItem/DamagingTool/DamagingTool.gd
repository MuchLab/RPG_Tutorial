extends EquippableItem

class_name DamagingTool

@export var effected_types : Array[DamageNodeType]

func interact_with_area(area : Area2D):
	if area is Damageable:
		for type in effected_types:
			if area.damage_node_types.has(type):
				print_debug("Match found at type " + type.display_name + " on " + area.name)
				_hit(area, type)
func _hit(area : Area2D, type : DamageNodeType):
	pass
