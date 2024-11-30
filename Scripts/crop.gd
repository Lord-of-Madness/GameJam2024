extends Node2D
class_name Crop


@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	print("do something")
