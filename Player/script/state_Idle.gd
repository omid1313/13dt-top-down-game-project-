# This script controls the player's idle behavior in the state machine
class_name State_Idle
extends State


# Reference to the walk state, used when the player starts moving
@onready var walk: State = $"../Walk"


# Called when entering the idle state
# Plays the idle animation to show the player standing still
func Enter() -> void:
	player.UpdateAnimation("Idle")
	pass


# Called when exiting the idle state
func Exit() -> void:
	pass


# Runs every frame while in the idle state
func Process(_delta: float) -> State:
	# If the player starts moving, switch to the walk state
	if player.direction != Vector2.ZERO:
		return walk

	# If not moving, keep the player still
	player.velocity = Vector2.ZERO
	return null


# Handles physics updates (not used for idle state)
func physics(_delta: float) -> State:
	return null


# Handles input events while idle (not used here)
func HandleInput(_event: InputEvent) -> State:
	return null
