extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	if not PlayerData.is_night:
		return
		
	MusicManager.interact.play()
	
	if $Sprite2D.frame < 4:
		$Sprite2D.frame += 1
	else:
		PlayerData.increment_turnip_count()
		RewardEffect.new_turnip()
		$Sprite2D.frame = 2
	
	PlayerData.second_life = true
	queue_free()
