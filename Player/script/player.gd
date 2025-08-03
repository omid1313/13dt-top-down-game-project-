extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	state_machine.Initialize(self)
	pass 


func _process(_delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	pass 


func _physics_process(_delta):
	move_and_slide()

func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	
	if direction == Vector2.ZERO:
		return false

	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	sprite_2d.scale.x = -0.1 if cardinal_direction == Vector2.LEFT else 0.1
	return true


func UpdateAnimation(state : String) -> void:
	if state == "Idle":
		animation_player.stop() # stop animation completely
	else:
		animation_player.play(state + "_" + AninDirection())

func AninDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
