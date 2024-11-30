extends Control

@onready var main_game = $"../"

func _on_button_pressed() -> void:
	main_game.pauseMenu()

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
