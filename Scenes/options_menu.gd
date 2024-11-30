extends Control

func _ready() -> void:
	$CheckBox.grab_focus()
	

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		MusicManager.shutupIamDebugging = true
	else:
		MusicManager.shutupIamDebugging = false
