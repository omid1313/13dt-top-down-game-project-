extends Area2D

# The number of coins required to unlock the door
@export var required_coins: int = 6

# The next scene that loads when the player uses the door
@export_file("*.tscn") var next_scene_path: String = "res://Survive_scene.tscn"


# Called when a body (like the player) enters the door area
func _on_body_entered(body: Node2D) -> void:
	# Ignore any object that is not the player
	if body.name != "Player":
		return

	# Check how many coins the player has collected
	var coins: int = 0

	# Try to get the coin count using the player’s function
	if body.has_method("get_coin_count"):
		coins = body.get_coin_count()
	else:
		# If no function, try reading directly from the variable
		var value = body.get("coin_counter")
		if value != null:
			coins = int(value)

	# If the player has enough coins, load the next scene
	if coins >= required_coins and next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
