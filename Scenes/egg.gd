extends Node2D

var is_player_in_range := false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if !is_player_in_range:
		return
		
	if Input.is_action_just_pressed("interact"):
		PlayerData.egg_count += 1
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	is_player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_player_in_range = false
