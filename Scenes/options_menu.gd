extends Control


func _ready() -> void:
	$TurnOff.grab_focus()
	

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_turn_off_pressed() -> void:
	MusicManager.mute()
