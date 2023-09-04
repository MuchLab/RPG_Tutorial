extends EquippableItem

class_name HarvestingTool

@export var effected_types : Array[ResourceNodeType]
@export var min_amount = 1
@export var max_amount = 1

func interact_with_body(body):
	if body is ResourceNode:
		for type in effected_types:
			if body.node_types.has(type):
				print_debug("Match found at type " + type.display_name + " on " + body.name)
				body.harvest(randi_range(min_amount, max_amount))
