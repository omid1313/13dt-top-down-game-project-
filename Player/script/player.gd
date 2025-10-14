extends CharacterBody2D

# Movement / facing 
@export var move_speed: float = 140.0
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

# Hearts HUD 
var hearts_list: Array[TextureRect] = []
var health: int = 3
var alive: bool = true
var coin_counter = 0

# Node refs 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: Node = $StateMachine 
@onready var coin_label =$Label

# Sets up the health bar and stores all heart icons in a list.
func _ready() -> void:
	if is_instance_valid(state_machine) and state_machine.has_method("Initialize"):
		state_machine.Initialize(self)

	# Build hearts list from the HUD
	var hearts_parent := $health_bar/HBoxContainer
	for child in hearts_parent.get_children():
		if child is TextureRect:
			hearts_list.append(child)
	update_heart_display()

func _process(_delta: float) -> void:
	# Read input
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	# Update facing based on input
	SetDirection()

func _physics_process(_delta: float) -> void:
	# Apply velocity then move
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

# ---------------- Facing / animation helpers ----------------
func SetDirection() -> bool:
	var new_dir: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false

	# Prefer axis-aligned cardinal directions for animation names
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	else:
		# If diagonal, prefer horizontal (feel free to change)
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir

	# Flip without changing size
	sprite_2d.flip_h = (cardinal_direction == Vector2.LEFT)
	return true

func UpdateAnimation(state: String) -> void:
	if state == "Idle":
		animation_player.stop()
	else:
		animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

# Health / hearts 
func take_damage(amount: int = 1) -> void:
	if health <= 0:
		return
	health = max(0, health - amount)
	update_heart_display()
	if health == 0:
		alive = false
		_die()

func update_heart_display() -> void:
	for i in range(hearts_list.size()):
		# show only remaining hearts
		hearts_list[i].visible = i < health

func _die() -> void:
	get_tree().reload_current_scene()

func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	coin_label.text = "Coin Count: " + str(coin_counter)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)
