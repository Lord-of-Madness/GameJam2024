extends CharacterBody2D

@export var move_speed : float = 100

@onready var player_sprite:AnimatedSprite2D = $AnimatedSprite2D
var Health:int
@export var MaxHP = 20
var is_alive:bool = true
var dead:bool = false
var facing_right:bool
var facing_left:bool
var facing_up:bool

signal health_change

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Health = MaxHP

func _process(delta: float) -> void:
	if Health <= 0 and not dead:
		die()
		if facing_right or facing_left:
			player_sprite.play("Death_right")
		elif facing_up:
			player_sprite.play("Death_up")
		else:
			player_sprite.play("Death")
		dead = true
		
func _physics_process(delta: float) -> void:
	if is_alive:
		# Get input direction
		var horizontal = Input.get_axis("left","right")
		var vertical = Input.get_axis("up", "down")
		
		var angle = atan2(vertical, horizontal)
		var actual_speed =  move_speed
		
		# Animation and idle state speed 0
		if ((angle >= PI*2 ) or (abs(horizontal) + abs(vertical)) == 0):
			player_sprite.play("Idle")
			facing_up = false
			facing_right = false
			facing_left = false
			actual_speed = 0
		else:
			input_handling()
			
		# Update velocity
		var xVelocity = cos(angle) * actual_speed
		var yVelocity = sin(angle) * actual_speed
		
		velocity = Vector2(xVelocity, yVelocity)
		
		# Move and Slide function uses velocity of character body to move character on map
		move_and_slide()		

func input_handling():
	if Input.get_action_strength("right"):
		player_sprite.play("Walk")
		facing_right = true
		facing_left = false
		facing_up = false
		player_sprite.flip_h = false
	elif Input.get_action_strength("left"):
		player_sprite.play("Walk")
		facing_right = false
		facing_left = true
		facing_up = false
		player_sprite.flip_h = true
	elif Input.get_action_strength("down"):
		player_sprite.play("Walk_down")
		facing_up = false
		facing_right = false
		facing_left = false
	else:
		player_sprite.play("Walk_up")
		facing_up = true
		facing_right = false
		facing_left = false
		
func take_damage(damage:int):	
	Health-=damage
	health_change.emit()
	camera_shake(Vector2.ZERO)
	flash_modulate(Color.RED)
	
func die():
	is_alive = false

func camera_shake(startpos):
	var dur = 0.3
	var tween = create_tween()
	var cam = get_viewport().get_camera_2d()
	for i in range(0,9):
		tween.tween_property(cam,"position",startpos+Vector2(rng.randfn()*2,rng.randfn()*2),dur/10)
	tween.tween_property(cam,"position",startpos,dur/10)
	
	
func flash_modulate(color:Color):
	var tween = create_tween()
	tween.tween_property(self,"modulate",color,0.3)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)


func _on_animated_sprite_2d_animation_finished() -> void:
	is_alive = true
	dead = false
	Health = MaxHP
	health_change.emit()
	get_tree().reload_current_scene()
