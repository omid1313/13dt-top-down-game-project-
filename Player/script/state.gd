class_name State extends Node

static var player


func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	return null

func physics( _delta : float) -> State:
	return null

func HandleInput( _event: InputEvent) -> State:
	return null 
