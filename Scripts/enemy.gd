extends CharacterBody2D
class_name Enemy


const SPEED = 300.0
var Active = false


func _physics_process(delta: float) -> void:
	if not Active: return
	var target = BaseCharacter.position
	velocity = position.direction_to(target)*SPEED
	move_and_slide()
	
