extends Node2D

# Fire hazard controller: cycles through OFF → WARN → ON with a Timer.
# Node references (composition)
@onready var fx: GPUParticles2D = $GPUParticles2D
@onready var area: Area2D = $Area2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer: Timer = $Timer


# State machine for the fire hazard
enum State { OFF, WARN, ON }


# Tunable durations for each state (in seconds)
@export var off_time: float = 3
@export var warn_time: float = 2
@export var on_time: float = 15


# Current state (starts OFF)
var state: int = State.OFF


# Called once when the node enters the scene tree. Sets up the timer and enters OFF.
func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_advance)
	_enter(State.OFF)



# Advances the state in the order: OFF → WARN → ON → OFF (loop).
func _advance() -> void:
	match state:
		State.OFF:
			_enter(State.WARN)
		State.WARN:
			_enter(State.ON)
		State.ON:
			_enter(State.OFF)



# Enters a specific state and applies visuals, collision, and next timer.
func _enter(s: int) -> void:
	state = s

	match state:
		# Invisible and safe. Collision disabled.
		State.OFF:
			fx.visible = false
			fx.emitting = false
			area.visible = false
			shape.set_deferred("disabled", true)
			timer.start(off_time)

		# Visible telegraph, still safe. Collision disabled.
		State.WARN:
			fx.visible = true
			fx.emitting = true
			area.visible = true
			shape.set_deferred("disabled", true)
			timer.start(warn_time)

		# Visible and dangerous. Collision enabled.
		State.ON:
			fx.visible = true
			fx.emitting = true
			area.visible = true
			shape.set_deferred("disabled", false)
			timer.start(on_time)



# When a body enters the Area2D while ON, the player should take the consequence.
# Current design: reload the scene if the Player touches the fire area.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()
