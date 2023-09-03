extends Node

class_name State

signal interrupt_state(state : State)

@export var can_move : bool = true
@export var can_direction : bool = true
@export var should_wander : bool = false

const PLAYBACK_PARAMETER_STR : String = "parameters/playback"

var character : CharacterBody2D
var next_state : State
var animation_tree : AnimationTree
static var default_direction : Vector2
static var is_invincible : bool = false

func state_process(_delta : float):
	pass
	
func state_input(_event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
