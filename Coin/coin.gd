extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Collect the coin when player body touches it
	if body.name == "Player":
		queue_free()
