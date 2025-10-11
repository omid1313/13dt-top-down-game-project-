extends Control


func _on_Start_pressed() -> void:
	get_tree().change_scene_to_file("res://Mainscene.tscn")


func _on_Exit_pressed() -> void:
	get_tree().quit() 


func _on_Options_pressed() -> void:
	pass # Replace with function body.
