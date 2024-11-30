extends Control


func _ready() -> void:
	$Button.grab_focus()
	

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_button_pressed() -> void:
	MusicManager.mute()
