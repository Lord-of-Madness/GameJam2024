extends Node2D

const MINING_MECHANIC_SCENE = preload("res://Scenes/mining_mechanic.tscn")

var is_player_in_area := false
var mining_minigame_node: Node2D = null

func _process(delta: float) -> void:
	if !is_player_in_area:
		return
		
	if Input.is_action_just_pressed("interact") and mining_minigame_node == null and !PlayerData.is_night:
		mining_minigame_node = MINING_MECHANIC_SCENE.instantiate()
		add_child(mining_minigame_node)
		
	var is_player_moving := Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("down") or Input.is_action_pressed("right")
	if mining_minigame_node != null and (is_player_moving or PlayerData.is_night):
		mining_minigame_node.queue_free()
		mining_minigame_node = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	is_player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_player_in_area = false
	
