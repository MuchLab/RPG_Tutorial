extends StaticBody2D

class_name ResourceNode

@export var node_types : Array[ResourceNodeType]
@export var starting_resources : int = 1
@export var pickup_type : PackedScene
@export var launch_speed : float = 75
@export var launch_duration : float = 0.25

var current_resources : int :
	set(resource_count):
		current_resources = resource_count
		if resource_count <= 0:
			queue_free()

func _ready() -> void:
	self.current_resources = starting_resources
	
func harvest(amount : int):
	for n in amount:
		spawn_resource()
	current_resources-=amount

func spawn_resource():
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	get_parent().add_child(pickup_instance)
	pickup_instance.position = position
	
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
	pickup_instance.launch(direction * launch_speed, launch_duration)
	
func harvest_effect():
	pass
