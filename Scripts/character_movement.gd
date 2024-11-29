extends CharacterBody2D

@export var move_speed : float = 100

func _physics_process(_delta):
	# Get input direction
	var horizontal = Input.get_axis("left","right")
	var vertical = Input.get_axis("up", "down")
	
	var angle = atan2(vertical, horizontal)
	var actual_speed =  move_speed
	
	if ((angle >= PI*2 )or (abs(horizontal) + abs(vertical)) == 0):
		actual_speed = 0
	
	# Update velocity
	var xVelocity = cos(angle) * actual_speed
	var yVelocity = sin(angle) * actual_speed
	
	velocity = Vector2(xVelocity, yVelocity)
	
	# Move and Slide function uses velocity of character body to move character on map
	move_and_slide()
