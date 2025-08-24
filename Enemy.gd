extends Node2D

@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 30
@export var randomize_rotation: bool = false

# Match your nodes:
@export var spawn_points_parent_path: NodePath = ^"SpawnPoints"   # child of this node
@export var enemies_container_path: NodePath = ^"."               # add enemies under this node

var _spawn_points: Array[Marker2D] = []
var _enemies_container: Node
var _player: Node2D  # ← NEW: reference to player (must be in "Player" group)

@onready var _timer: Timer = $Timer

func _ready() -> void:
	randomize()

	# get container (the root itself by default)
	_enemies_container = get_node(enemies_container_path)

	# collect Marker2D children under SpawnPoints
	var parent := get_node(spawn_points_parent_path)
	_spawn_points.clear()
	for c in parent.get_children():
		if c is Marker2D:
			_spawn_points.append(c)

	if _spawn_points.is_empty():
		push_warning("No spawn points found under %s" % spawn_points_parent_path)

	# find the player by group (add your player to the "Player" group in the editor)
	_player = get_tree().get_first_node_in_group("Player")
	if _player == null:
		push_warning("No node in group 'Player' found. Enemies will have no target.")

	_timer.wait_time = spawn_interval
	_timer.timeout.connect(_on_timer_timeout)
	_timer.start()

func _on_timer_timeout() -> void:
	if enemy_scene == null or _spawn_points.is_empty():
		return
	if _enemies_container.get_child_count() >= max_enemies:
		return

	var sp: Marker2D = _spawn_points.pick_random()
	var ene: Node2D = enemy_scene.instantiate()

	# 1) Add as a sibling of the marker so they share the same local space
	var markers_parent := sp.get_parent()          # this is your SpawnPoints node
	markers_parent.add_child(ene)                  # temporarily parent under SpawnPoints
	ene.position = sp.position                     # exact local position match

	# 2) Reparent to container but keep the world transform
	if _enemies_container != markers_parent:
		ene.reparent(_enemies_container, true)     # 'true' keeps global transform

	# 3) Hand the player target to the enemy (if it supports set_target)
	if _player and ene.has_method("set_target"):
		ene.set_target(_player)

	if randomize_rotation:
		ene.rotation = randf() * TAU
