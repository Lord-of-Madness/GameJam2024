extends Node2D

var AnimPlayer: AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AnimPlayer = get_node("Graphic/AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func attack_anim():
	AnimPlayer.play("Right")
