extends Control

func _ready() -> void:
	visibility_changed.connect(func():
		if visible:
			$VBoxContainer/PlayAgain.grab_focus()
			)

func showStats() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$VBoxContainer2/SurvivedNights.text = "Survived nights: " + str(PlayerData.elapsed_nights)
	$VBoxContainer2/KilledEnemies.text = "Enemies killed: " + str(PlayerData._enemy_kill_count)
	$VBoxContainer2/Ores.text = "Ores mined: " + str(PlayerData._max_ore_count)
	$VBoxContainer2/Turnips.text = "Turnips gathered: " + str(PlayerData._max_turnip_count)
	$VBoxContainer2/Eggs.text = "Eggs picked-up: " + str(PlayerData._max_eggs_count)

func restart():
	MusicManager.reset_music()
	PlayerData.is_dead = false
	self.hide()

func _on_play_again_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false		
		
	restart()
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_back_to_menu_pressed() -> void:
	restart()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
