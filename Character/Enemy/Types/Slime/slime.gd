extends CharacterBody2D

class_name Slime
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: Node = $CharacterStateMachine
var orignal_position : Vector2
func _ready() -> void:
	animation_tree.active = true
	orignal_position = self.global_position
	
func _physics_process(_delta: float) -> void:
	if state_machine.check_if_can_direction():
		facing_direction_changed()
	move_and_slide()
	
func facing_direction_changed():
	if velocity.x > 0:
		sprite.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true
