extends Node2D

var player:Player
@onready var label = $Label

const base_text_mouse = "[E] to "
const base_text_contr = "(X) to "

var active_areas = []
var can_interact = true
var current_node: Node2D

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(delta):
	if PlayerData.is_night or PlayerData.in_mechanic:
		if active_areas.size() && can_interact:
			if not active_areas[0].get_parent().name == "EvilCrop":
				label.hide()
				return
	
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		if get_tree().current_scene.get_node("BaseCharacter").mouse_mode:
			label.text = base_text_mouse + active_areas[0].action_name
		else:
			label.text = base_text_contr + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 20
		label.global_position.x -= label.size.x / 2
		label.show()
		if active_areas[0].get_parent().name == "EvilCrop" and not PlayerData.is_night:
			label.hide()
	else:
		label.hide()
	

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_squared_to(area1.global_position)
	var area2_to_player = player.global_position.distance_squared_to(area2.global_position)
	return area1_to_player < area2_to_player
	

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
