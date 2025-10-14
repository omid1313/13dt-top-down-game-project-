extends Control

# Starts the game 
func _on_Start_pressed() -> void:
	get_tree().change_scene_to_file("res://Mainscene.tscn")

# Exits from the game 
func _on_Exit_pressed() -> void:
	get_tree().quit() 

# Opens the option setting
func _on_Options_pressed() -> void:
	pass 
