extends CharacterBody2D

# Movement / facing.
@export var move_speed: float = 140.0
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

# Hearts HUD and basic player state.
var hearts_list: Array[TextureRect] = []
var health: int = 3
var alive: bool = true
var coin_counter: int = 0

# Node references.
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: Node = $StateMachine
@onready var coin_label: Label = $Label


# Runs once when the player enters the scene.
# Sets up state machine and collects heart icons from the HUD.
func _ready() -> void:
	if is_instance_valid(state_machine) and state_machine.has_method("Initialize"):
		state_machine.Initialize(self)

	var hearts_parent := $health_bar/HBoxContainer
	for child in hearts_parent.get_children():
		if child is TextureRect:
			hearts_list.append(child)

	update_heart_display()



# Reads player input each frame and updates the facing direction.
func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	SetDirection()



# Applies movement physics each frame based on the input direction.
func _physics_process(_delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * move_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()



# Chooses the cardinal facing (left, right, up, down) from the input.
# Also flips the sprite to face left or right.
func SetDirection() -> bool:
	var new_dir: Vector2 = cardinal_direction

	if direction == Vector2.ZERO:
		return false

	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	else:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	sprite_2d.flip_h = (cardinal_direction == Vector2.LEFT)
	return true



# Plays the correct animation for the current state and direction.
func UpdateAnimation(state: String) -> void:
	if state == "Idle":
		animation_player.stop()
	else:
		animation_player.play(state + "_" + AnimDirection())



# Returns "up", "down" or "side" based on the facing direction.
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"



# Reduces health and updates the hearts. Reloads scene if health reaches zero.
func take_damage(amount: int = 1) -> void:
	if health <= 0:
		return

	health = max(0, health - amount)
	update_heart_display()

	if health == 0:
		alive = false
		_die()



# Shows or hides hearts to match the current health value.
func update_heart_display() -> void:
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health



# Handles player death by reloading the current scene.
func _die() -> void:
	get_tree().reload_current_scene()



# Sets the coin counter and updates the on-screen label.
func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	coin_label.text = "Coin Count: " + str(coin_counter)



# Collects a coin when entering a coin area and increases the counter.
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)



# Returns the current coin count for other nodes (like the door).
func get_coin_count() -> int:
	return coin_counter
