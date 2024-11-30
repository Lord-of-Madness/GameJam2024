extends Node2D

const MINING_MECHANIC_SCENE = preload("res://Scenes/mining_mechanic.tscn")
const TIME_TO_SHAKE := 0.5
const SHAKE_POWER := 1.0
const ORE_OFFSET := Vector2(0.0, -5.0)

var is_player_in_area := false
var mining_minigame_node: Node2D = null
var h_flip := false
var interaction_target: Node2D = null
var interaction_target_original_pos: Vector2
var elapsed: float = 0.0
var rng := RandomNumberGenerator.new()

func _process(delta: float) -> void:
	update_ore_interaction_animation(delta)
	
	if !is_player_in_area:
		return
		
	if mining_minigame_node == null:
		on_player_interact_end()
		
	if Input.is_action_just_pressed("interact") and mining_minigame_node == null and !PlayerData.is_night:
		mining_minigame_node = MINING_MECHANIC_SCENE.instantiate()
		add_child(mining_minigame_node)
		on_player_interact_start()
		
	var is_player_moving := Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("down") or Input.is_action_pressed("right")
	if mining_minigame_node != null and (is_player_moving or PlayerData.is_night):
		mining_minigame_node.queue_free()
		mining_minigame_node = null
		PlayerData.in_mechanic = false
		on_player_interact_end()

func update_ore_interaction_animation(delta: float):
	if interaction_target == null:
		return
		
	var direction := Vector2(rng.randf_range(0.0, 1.0), rng.randf_range(0.0, 1.0)).normalized()
	interaction_target.position = interaction_target_original_pos + direction * SHAKE_POWER
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	is_player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_player_in_area = false
		
func on_player_interact_start():
	PlayerData.player.is_doing_mechanic = true
	PlayerData.player.get_node("AnimatedSprite2D").play("Interact_up")
	
	interaction_target = get_nearest_ore()
	interaction_target_original_pos = interaction_target.position
	interaction_target.get_node("CPUParticles2D").emitting = true
	
	MusicManager.mining.play()
	
func on_player_interact_end():
	if h_flip:
		PlayerData.player.scale.x *= -1.0
	PlayerData.player.is_doing_mechanic = false
	
	if interaction_target != null:
		interaction_target.position = interaction_target_original_pos
		interaction_target.get_node("CPUParticles2D").emitting = false
		interaction_target = null
		
		MusicManager.mining.stop()

func get_nearest_ore():
	var nearest_distance_squared := INF
	var nearest_node: Node2D = null
	
	for node in get_children():
		if node is not Sprite2D:
			continue
			
		var node_position: Vector2 = position + node.position
		var distance_squared: float = node_position.distance_squared_to(PlayerData.player.position)
		
		if distance_squared < nearest_distance_squared:
			nearest_distance_squared = distance_squared
			nearest_node = node
				
	return nearest_node
			
