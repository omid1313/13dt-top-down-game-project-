extends Area2D

@export var required_coins: int = 6
@export_file("*.tscn") var next_scene_path: String = "res://Survive_scene.tscn"


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	var coins := 0
	if body.has_method("get_coin_count"):
		coins = body.get_coin_count()
	else:
		var v = body.get("coin_counter")  
		if v != null:
			coins = int(v)

	if coins >= required_coins and next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
