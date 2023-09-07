extends Area2D

class_name Pickup

@export var resource_type : Item
@export var absorb_velocity : float = 75
@export var should_absorb : bool = false
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player_detector: Area2D = $PlayerDetector

var launch_velocity : Vector2 = Vector2.ZERO
var move_duration : float = 0
var time_since_launch : float = 0

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	player_detector.set_deferred("monitoring", false)

var launching : bool = false :
	set(is_launching):
		launching = is_launching
		collision_shape.disabled = launching
		player_detector.set_deferred("monitoring", !launching)

func _process(delta: float) -> void:
	if launching:
		position += launch_velocity * delta
		time_since_launch += delta
		
		if time_since_launch >= move_duration:
			launching = false
	elif should_absorb:
		var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
		var absorb_direction = position.direction_to(player.global_position)
		position += absorb_direction * absorb_velocity * delta

func launch(velocity : Vector2, duration : float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

func _on_body_entered(body : Node2D):
	var inventory = body.find_child("Inventory")
	if inventory:
		inventory.add_resources(resource_type, 1)
		queue_free()


func _on_player_detector_body_entered(body: Node2D) -> void:
	should_absorb = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	should_absorb = false
