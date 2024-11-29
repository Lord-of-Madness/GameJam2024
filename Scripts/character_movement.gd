extends CharacterBody2D

@export var move_speed : float = 100

@onready var player_sprite = $AnimatedSprite2D

func _physics_process(_delta):
		
	# Get input direction
	var horizontal = Input.get_axis("left","right")
	var vertical = Input.get_axis("up", "down")
	
	var angle = atan2(vertical, horizontal)
	var actual_speed =  move_speed
	
	# Animation and idle state speed 0
	if ((angle >= PI*2 ) or (abs(horizontal) + abs(vertical)) == 0):
		get_node("AnimatedSprite2D").play("Idle")
		actual_speed = 0
	else:
		if Input.get_action_strength("right"):
			get_node("AnimatedSprite2D").play("Walk")
			player_sprite.flip_h = false
		elif Input.get_action_strength("left"):
			get_node("AnimatedSprite2D").play("Walk")
			player_sprite.flip_h = true
		elif Input.get_action_strength("down"):
			get_node("AnimatedSprite2D").play("Walk_down")
		else:
			get_node("AnimatedSprite2D").play("Walk_up")
		
	# Update velocity
	var xVelocity = cos(angle) * actual_speed
	var yVelocity = sin(angle) * actual_speed
	
	velocity = Vector2(xVelocity, yVelocity)
	
	# Move and Slide function uses velocity of character body to move character on map
	move_and_slide()
