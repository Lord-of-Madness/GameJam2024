extends Control
	

func resume():
	get_tree().paused = false
	self.hide()

func pause():
	get_tree().paused = true
	self.show()
	$VBoxContainer/Resume.grab_focus()
	
func inputs():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _process(delta: float) -> void:
	inputs()

func _on_resume_pressed() -> void:
	resume()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
