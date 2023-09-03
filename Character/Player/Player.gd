extends CharacterBody2D

@export var max_speed = 200
@export var acceleration = 25
@export var friction = 25
@onready var animation_tree: AnimationTree = $AnimationTree
var playback : AnimationNodeStateMachinePlayback

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/run/blend_position", direction)
		animation_tree.set("parameters/attack/blend_position", direction)
#
#	if direction != Vector2.ZERO:
#		animation_tree.set("parameters/idle/blend_position", direction)
#		animation_tree.set("parameters/run/blend_position", direction)
#		playback.travel("run")
#		velocity = velocity.move_toward(direction * max_speed, acceleration)
#	else:
#		playback.travel("idle")
#		velocity = velocity.move_toward(Vector2.ZERO, friction)

	move_and_slide()
