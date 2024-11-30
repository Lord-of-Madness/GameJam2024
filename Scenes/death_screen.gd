extends Control


func restart():
	MusicManager.reset_music()
	self.hide()

func _on_play_again_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false		
		
	restart()
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_back_to_menu_pressed() -> void:
	restart()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
