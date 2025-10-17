# This script controls the player's state machine.
# It manages switching between different states like Idle and Walk.
class_name PlayerStateMachine
extends Node


# Stores all available player states
var states: Array[State]

# References to the current and previous states
var prev_state: State
var current_state: State


# Runs when the node enters the scene.
# Starts with processing disabled until the state machine is initialized.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass



# Runs every frame to process the current state's logic.
func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta))
	pass



# Runs every physics frame to process physics-related state logic.
func _physics_process(delta: float) -> void:
	ChangeState(current_state.Process(delta))
	pass



# Handles unhandled player inputs and passes them to the current state.
func _unhandled_input(event: InputEvent) -> void:
	ChangeState(current_state.HandleInput(event))
	pass



# Initializes the state machine by finding all state nodes
# and setting the first one as the starting state.
func Initialize(_player: Node) -> void:
	states = []

	for child in get_children():
		if child is State:
			states.append(child)

	if states.size() > 0:
		states[0].player = _player
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT



# Switches from one state to another.
# Ensures the current state is exited properly before entering a new one.
func ChangeState(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	current_state.Enter()
