extends Control



# Return to main menu
func _on_Return_pressed() -> void:
	get_tree(). change_scene_to_file("res://MainMenu/Mainmenu.tscn")



# Exit the game 
func _on_Exit_pressed() -> void:
	get_tree(). quit()
