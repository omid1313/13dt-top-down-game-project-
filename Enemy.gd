# EnemyOrSpawner.gd  (Godot 4.x)
extends Node2D

enum Role { SPAWNER, ENEMY }
@export var role: Role = Role.SPAWNER

# ---------- ENEMY (movement) ----------
@export var speed: float = 140.0
@export var stop_distance: float = 8.0
@export var face_target: bool = true
@export var debug_logs: bool = false

var _target: Node2D = null

func set_target(t: Node2D) -> void:
	_target = t
	if debug_logs: print("[Enemy] set_target -> ", t)

# ---------- SPAWNER ----------
@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 30
@export var randomize_rotation: bool = false
@export var spawn_points_parent_path: NodePath = ^"SpawnPoints"
@export var enemies_container_path: NodePath = ^"."

var _timer: Timer = null
var _spawn_points: Array[Marker2D] = []
var _enemies_container: Node = null
var _player: Node2D = null

# ---------- LIFECYCLE ----------
func _ready() -> void:
	if role == Role.SPAWNER:
		_setup_spawner()
	else:
		_setup_enemy()

func _physics_process(delta: float) -> void:
	if role != Role.ENEMY:
		return

	if _target == null:
		_target = get_tree().get_first_node_in_group("Player")
		if _target == null:
			return

	var to_player := _target.global_position - global_position
	var dist := to_player.length()

	if face_target and dist > 0.001:
		rotation = to_player.angle()

	# Use CharacterBody2D-style movement if available; else use Node2D-style
	var has_cb := has_method("move_and_slide")

	if dist <= stop_distance:
		if has_cb:
			set("velocity", Vector2.ZERO)
			call("move_and_slide")
		return

	var dir := to_player.normalized()

	if has_cb:
		# Works for CharacterBody2D without any casting
		set("velocity", dir * speed)
		call("move_and_slide")
	else:
		# Generic Node2D movement
		position += dir * speed * delta

# ---------- SPAWNER ----------
func _setup_spawner() -> void:
	randomize()

	_enemies_container = get_node_or_null(enemies_container_path)
	if _enemies_container == null:
		_enemies_container = self

	var parent := get_node_or_null(spawn_points_parent_path)
	_spawn_points.clear()
	if parent:
		for c in parent.get_children():
			if c is Marker2D:
				_spawn_points.append(c)

	if _spawn_points.is_empty():
		push_warning("No spawn points found under %s" % spawn_points_parent_path)

	_player = get_tree().get_first_node_in_group("Player")
	if _player == null:
		push_warning("No node in group 'Player' found. Enemies will have no target.")

	_timer = get_node_or_null("Timer") as Timer
	if _timer:
		_timer.wait_time = spawn_interval
		_timer.timeout.connect(_on_timer_timeout)
		_timer.start()
	else:
		push_warning("No Timer child found; spawner won't run.")

func _on_timer_timeout() -> void:
	if enemy_scene == null or _spawn_points.is_empty():
		return
	if _enemies_container.get_child_count() >= max_enemies:
		return

	var sp: Marker2D = _spawn_points.pick_random()
	var enemy := enemy_scene.instantiate()

	# place exactly at the Marker2D
	var markers_parent := sp.get_parent()
	markers_parent.add_child(enemy)
	enemy.position = sp.position
	if _enemies_container != markers_parent:
		enemy.reparent(_enemies_container, true)  # keep world transform

	if randomize_rotation:
		enemy.rotation = randf() * TAU

	# hand off the player target
	if _player and enemy.has_method("set_target"):
		enemy.set_target(_player)

# ---------- ENEMY ----------
func _setup_enemy() -> void:
	# fallback target if spawner didn't set it
	if _target == null:
		_target = get_tree().get_first_node_in_group("Player")
	if debug_logs:
		print("[Enemy] Ready. type=", get_class(), " target=", _target)
