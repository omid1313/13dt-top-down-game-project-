# This script controls the player's walking behavior in the state machine
class_name State_Walk
extends State


# How fast the player moves while walking
@export var move_speed: float = 60.0

# Reference to the idle state, used when the player stops moving
@onready var idle: State_Idle = $"../Idle"


# Called when entering the walking state
func Enter() -> void:
	player.UpdateAnimation("Walk")
	pass


# Called when exiting the walking state
func Exit() -> void:
	pass


# Runs every frame while in the walking state
func Process(_delta: float) -> State:
	# If the player stops moving, return to the idle state
	if player.direction == Vector2.ZERO:
		return idle

	# Move the player based on their input direction and movement speed
	player.velocity = player.direction * move_speed

	# Update animation if direction changes
	if player.SetDirection():
		player.UpdateAnimation("Walk")

	return null


# Handles physics updates (not used in this state)
func physics(_delta: float) -> State:
	return null


# Handles input events while walking (not used here)
func HandleInput(_event: InputEvent) -> State:
	return null
