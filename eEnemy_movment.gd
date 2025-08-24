extends CharacterBody2D


@export var speed: float = 120.0
@export var stop_distance: float = 8.0
@export var face_target: bool = true

var _target: Node2D = null

func set_target(t: Node2D) -> void:
	_target = t

func _ready() -> void:
	# fallback: auto-find player by group if spawner didn’t set it yet
	if _target == null:
		_target = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if _target == null:
		velocity = Vector2.ZERO
		return

	var to_player := _target.global_position - global_position
	var dist := to_player.length()

	if dist > stop_distance:
		velocity = to_player.normalized() * speed
	else:
		velocity = Vector2.ZERO

	if face_target and dist > 0.001:
		rotation = to_player.angle()

	move_and_slide()
	
