extends StaticBody2D

class_name ResourceNode

@export var node_types : Array[ResourceNodeType]
@export var starting_resources : int = 1
@export var pickup_type : PackedScene
@export var depleted_effect : PackedScene
@export var launch_speed : float = 75
@export var launch_duration : float = 0.25
@export var effect_interval_time = 0.1
@export var swing_effect_rotation = 5


var current_resources : int :
	set(resource_count):
		current_resources = resource_count
		if resource_count <= 0:
			var depleted_effect_instance = depleted_effect.instantiate()
			depleted_effect_instance.position = position
			get_parent().add_child(depleted_effect_instance)
			depleted_effect_instance.emitting = true
			queue_free()

func _ready() -> void:
	self.current_resources = starting_resources
	
func harvest(amount : int):
	for n in amount:
		spawn_resource()
	current_resources-=amount
	harvest_effect()

func spawn_resource():
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	get_parent().add_child(pickup_instance)
	pickup_instance.position = position
	
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
	pickup_instance.launch(direction * launch_speed, launch_duration)

func create_flash_effect():
	var flash_effect_tween : Tween = get_tree().create_tween()
	var sprite : Sprite2D = find_child("Sprite2D")
	flash_effect_tween.tween_property(sprite, "material:shader_parameter/flash_state", 1, effect_interval_time)
	flash_effect_tween.tween_property(sprite, "material:shader_parameter/flash_state", 0, effect_interval_time)
	flash_effect_tween.set_loops(2)
func create_swing_effect():
	var swing_effect_tween : Tween = get_tree().create_tween()
	var sprite : Sprite2D = find_child("Sprite2D")
	swing_effect_tween.tween_property(sprite, "rotation_degrees", -swing_effect_rotation, effect_interval_time)
	swing_effect_tween.tween_property(sprite, "rotation_degrees", swing_effect_rotation, effect_interval_time)
	swing_effect_tween.set_loops(2)
	swing_effect_tween.connect("finished", _on_swing_effect_tween_finished)
	

func harvest_effect():
	create_flash_effect()
	create_swing_effect()
	
func _on_swing_effect_tween_finished():
	$Sprite2D.rotation = 0
