extends CharacterBody2D
class_name Player
enum facing {UP,DOWN,LEFT,RIGHT,NONE}

var guns = ["Shoot","Bazooka"]
var gun_dmg = {"Shoot":1,"Bazooka":5}
@export_range(0,1) var current_gun:int = 0


@export var move_speed : float = 100

@onready var player_sprite:AnimatedSprite2D = $AnimatedSprite2D
var Health:int
@export var MaxHP = 20
var is_alive:bool = true
var face:facing = facing.NONE
var collision:KinematicCollision2D

@onready var bulletScene:PackedScene = preload("res://Scenes/bullet.tscn")

var mouse_mode = true

var last_joy_aim:Vector2

@onready var arrowbase:Node2D = $ArrowBase

signal health_change
signal death_signal

var rng = RandomNumberGenerator.new()

var is_doing_mechanic := false

func _ready() -> void:
	Health = MaxHP
	arrowbase.visible = false
	$ArrowBase/AnimatedSprite2D.animation = guns[current_gun]


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		if not mouse_mode:
			arrowbase.visible = false
		mouse_mode = true
	elif event is InputEventJoypadButton:
		mouse_mode = false
		if not get_parent().day:
			arrowbase.visible = true
	if mouse_mode:
		if not get_parent().day:
			if (event is InputEventMouseMotion):
				arrowbase.rotation = get_global_mouse_position().angle_to_point(position)
			if(event.is_action_pressed("Aim")):
				arrowbase.visible = true
			elif(event.is_action_released("Aim")):
				arrowbase.visible = false
	else:
		if event is InputEventJoypadMotion and not get_parent().day:
			var vec = Input.get_vector("AimJoy RIGHT","AimJoy LEFT","AimJoy DOWN","AimJoy UP")
			if vec != Vector2.ZERO:
				last_joy_aim = vec
			arrowbase.rotation =last_joy_aim.angle()
	if not get_parent().day and event.is_action("Shoot") and (Input.is_action_pressed("Aim") or not mouse_mode):
		shoot(arrowbase.rotation)
		
	if abs(arrowbase.rotation)>=PI/2:
		$ArrowBase/AnimatedSprite2D.flip_v = true
	else:
		$ArrowBase/AnimatedSprite2D.flip_v = false
		
func _physics_process(delta: float) -> void:
	if get_parent().day:
		arrowbase.visible = false
	if is_alive:
		# Get input direction
		var horizontal = Input.get_axis("left","right")
		var vertical = Input.get_axis("up", "down")
		
		var angle = atan2(vertical, horizontal)
		var actual_speed =  move_speed
		
		if !is_doing_mechanic:
			# Animation and idle state speed 0
			if ((angle >= PI*2 ) or (abs(horizontal) + abs(vertical)) == 0):
				player_sprite.play("Idle")
				face = facing.NONE
				actual_speed = 0
			else:
				input_handling()
		
			velocity = Vector2(cos(angle), sin(angle))* actual_speed
			
			# Move and Slide function uses velocity of character body to move character on map
			if move_and_slide():
				for index in get_slide_collision_count():
					var col = get_slide_collision(index)
					if col.get_collider().is_in_group("Crops"):
						print("collided")
		
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

func shoot(rot:float):
	$ArrowBase/AnimatedSprite2D.play()#guns[current_gun] #Should be already set for aiming
	var bullet:RigidBody2D = bulletScene.instantiate()
	get_parent().add_child(bullet)
	bullet.launch(position,rot,gun_dmg[guns[current_gun]])
	$Gunshot.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	is_alive = true
	Health = MaxHP
	health_change.emit()
	death_signal.emit()
