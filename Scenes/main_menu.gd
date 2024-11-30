extends Control

var in_focus:Button

func _ready() -> void:
	$VBoxContainer/Button.grab_focus()
	in_focus = $VBoxContainer/Button

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if in_focus.has_focus():
			pass
		else: in_focus = $VBoxContainer/Button
		if event.is_action_pressed("interact"):
			in_focus.button_pressed

func _on_start_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
