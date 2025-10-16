extends Control

# Starts the game 
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Mainscene.tscn")


func _on_option_pressed() -> void:
	pass # Replace with function body.

# Exit from game 
func _on_exit_pressed() -> void:
	get_tree().quit() 
