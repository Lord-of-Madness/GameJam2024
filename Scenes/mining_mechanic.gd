class_name MinihMechanic
extends Node2D

const SPEED := 256.0

var direction := 1.0
var max_x: float
var middle_x: float

func _ready() -> void:
	max_x = $Background.size.x - $Background/HitBox.size.x
	middle_x = max_x / 2.0

func _process(delta: float) -> void:
	$Background/HitBox.position.x += SPEED * delta * direction
	
	if $Background/HitBox.position.x >= max_x or $Background/HitBox.position.x < 0.0:
		direction *= -1.0
		
	if Input.is_action_just_pressed("interact") and $Background/HitBox.position.x <= middle_x <= $Background/HitBox.position.x + $Background/HitBox.size.x:
		PlayerData.increment_ore_count()
		queue_free()
