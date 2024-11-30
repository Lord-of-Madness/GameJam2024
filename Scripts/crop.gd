extends Node2D
class_name Crop


@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	if $Sprite2D.frame < 4:
		$Sprite2D.frame += 1
	else:
		PlayerData.increment_turnip_count()
		$Sprite2D.frame = 2
		
