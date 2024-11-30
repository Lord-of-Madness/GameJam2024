extends CharacterBody2D

enum facing {UP,DOWN,LEFT,RIGHT,NONE}

@export var move_speed : float = 100

@onready var player_sprite:AnimatedSprite2D = $AnimatedSprite2D
var Health:int
@export var MaxHP = 20
var is_alive:bool = true
var face:facing = facing.NONE

var mouse_mode = true

var last_joy_aim:Vector2

@onready var arrowbase:Node2D = $ArrowBase

signal health_change
signal death_signal

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Health = MaxHP
	arrowbase.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		if not mouse_mode:
			arrowbase.visible = false
		mouse_mode = true
	elif event is InputEventJoypadButton:
		mouse_mode = false
		arrowbase.visible = true
	if mouse_mode:
		if (event is InputEventMouseMotion):
			arrowbase.rotation = get_global_mouse_position().angle_to_point(position)
		if(event.is_action_pressed("Aim")):
			arrowbase.visible = true
		elif(event.is_action_released("Aim")):
			arrowbase.visible = false
	else:
		if event is InputEventJoypadMotion:
			var vec = Input.get_vector("AimJoy RIGHT","AimJoy LEFT","AimJoy DOWN","AimJoy UP")
			if vec != Vector2.ZERO:
				last_joy_aim = vec
			arrowbase.rotation =last_joy_aim.angle()
		
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
			face = facing.NONE
			actual_speed = 0
		else:
			input_handling()
		
		velocity = Vector2(cos(angle), sin(angle))* actual_speed
		
		# Move and Slide function uses velocity of character body to move character on map
		move_and_slide()		
func input_handling():
	if Input.get_action_strength("right"):
		player_sprite.play("Walk")
		face = facing.RIGHT
		player_sprite.flip_h = false
	elif Input.get_action_strength("left"):
		player_sprite.play("Walk")
		face = facing.LEFT
		player_sprite.flip_h = true
	elif Input.get_action_strength("down"):
		player_sprite.play("Walk_down")
		face = facing.DOWN
	else:
		player_sprite.play("Walk_up")
		face = facing.UP
		
func take_damage(damage:int):	
	Health-=damage
	health_change.emit()
	camera_shake(Vector2.ZERO)
	flash_modulate(Color.RED)
	if Health <= 0 and is_alive:
		die()
	
func die():
	match face:
		facing.RIGHT,facing.LEFT :
			player_sprite.play("Death_right")
		facing.UP:
			player_sprite.play("Death_up")
		_:
			player_sprite.play("Death")
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
	Health = MaxHP
	health_change.emit()
	death_signal.emit()
