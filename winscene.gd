extends Control


func _on_Return_pressed() -> void:
	get_tree(). change_scene_to_file("res://MainMenu/Mainmenu.tscn")


func _on_Exit_pressed() -> void:
	get_tree(). quit()
