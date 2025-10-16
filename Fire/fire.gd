extends Node2D

@onready var fx: GPUParticles2D = $GPUParticles2D
@onready var area: Area2D = $Area2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer: Timer = $Timer

enum State { OFF, WARN, ON }

@export var off_time: float = 3 
@export var warn_time: float = 2
@export var on_time: float = 15

var state: int = State.OFF             

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_advance)
	_enter(State.OFF)

func _advance() -> void:
	match state:
		State.OFF:  _enter(State.WARN)
		State.WARN: _enter(State.ON)
		State.ON:   _enter(State.OFF)

func _enter(s: int) -> void:           
	state = s
	match state:
		State.OFF:
			fx.visible = false
			fx.emitting = false
			area.visible = false
			shape.set_deferred("disabled", true)
			timer.start(off_time)

		State.WARN:
			fx.visible = true
			fx.emitting = true   
			area.visible = true
			shape.set_deferred("disabled", true)
			timer.start(warn_time)

		State.ON:
			fx.visible = true
			fx.emitting = true
			area.visible = true
			shape.set_deferred("disabled", false)
			timer.start(on_time)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene() 
