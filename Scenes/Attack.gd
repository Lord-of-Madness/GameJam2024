extends Node2D
class_name Attack
var AnimPlayer: AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AnimPlayer = get_node("Graphic/AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func attack_anim(dir:Vector2):
	$AudioStreamPlayer2D.play()
	match dir:
		Vector2.LEFT:
			AnimPlayer.play("Right")
		Vector2.RIGHT:
			AnimPlayer.play("Left")
		Vector2.UP:
			AnimPlayer.play("Back")
		Vector2.DOWN:
			AnimPlayer.play("Forward")
