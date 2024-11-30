extends Control


func _on_start_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()