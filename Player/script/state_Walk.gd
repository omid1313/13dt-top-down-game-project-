class_name State_Walk extends State 

@export var move_speed : float = 60.0
@onready var idle: State_Idle = $"../Idle"

func Enter() -> void:
	player.UpdateAnimation("Walk")
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("Walk")
	return null

func physics( _delta : float) -> State:
	return null

func HandleInput( _event: InputEvent) -> State:
	return null 
