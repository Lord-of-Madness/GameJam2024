extends CharacterBody2D

@export var move_speed : float = 100

var Health:int = 20

var rng = RandomNumberGenerator.new()

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
func take_damage(damage:int):
	Health-=damage
	camera_shake(Vector2.ZERO)
	flash_modulate(Color.RED)

func camera_shake(startpos):
	var dur = 0.3
	var tween = create_tween()
	var cam = get_viewport().get_camera_2d()
	for i in range(0,9):
		tween.tween_property(cam,"position",startpos+Vector2(rng.randfn()*5,rng.randfn()*5),dur/10)
	tween.tween_property(cam,"position",startpos,dur/10)
	
	
func flash_modulate(color:Color):
	var tween = create_tween()
	tween.tween_property(self,"modulate",color,0.3)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
