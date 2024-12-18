extends Node2D

var is_player_in_range := false

func _process(delta: float) -> void:
	if !is_player_in_range:
		return
		
	if Input.is_action_just_pressed("interact") and !PlayerData.is_night:
		MusicManager.interact.play()
		PlayerData.increment_egg_count()
		queue_free()
		RewardEffect.new_egg()

func _on_area_2d_body_entered(body: Node2D) -> void:
	is_player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_player_in_range = false
