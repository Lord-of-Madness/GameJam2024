extends CharacterBody2D
class_name Enemy


@export_group("GameProperties")
@export_range(0,100,5,"or_greater") var Health := 15.0
@export_range(0,100,5,"or_greater") var SPEED = 70.0
@export_subgroup("Combat Properties")
##Attacks per Second
@export var AttackSpeed : float= 1.0
##Attacks range in tiles
@export var AttackRange : int= 1
##Damage dealt
@export var damage : int= 1
var day = true : set = day_setter
func day_setter(val):
	if val:
		$DaySprite.visible = true
		$Sprite2D.visible = false
	else:
		$DaySprite.visible = false
		$Sprite2D.visible = true
	day = val
var canAttack:bool  = true
var Cooldown:float = 0

@onready var AttackNode:Attack = get_node("Attack")

var animPlayer:AnimationPlayer

var Active = false : set = set_active
func set_active(val):
	if val and Health<=0:return
	Active = val
		
var BaseCharacter:Player
func _ready() -> void:
	Health += PlayerData.enemy_max_hp_bonus
	BaseCharacter = get_node("../BaseCharacter")
	animPlayer = get_node("Sprite2D/AnimationPlayer")
	animPlayer.play("Idle")
	BaseCharacter.death_signal.connect(func():Active = false)
	get_parent().connect("daybegins",day_begins)
	get_parent().connect("nightbegins",night_begins)

func _process(delta: float) -> void:
	if not canAttack:
		Cooldown-=delta
		if(Cooldown<=0):
			canAttack = true
			
	elif Active:
		if(BaseCharacter.position.distance_to(position)<AttackRange*16):
			attack()
			BaseCharacter.take_damage(damage)

func _physics_process(delta: float) -> void:
	if not Active: return
	var target = BaseCharacter.position
	velocity = position.direction_to(target)*SPEED
	move_and_slide()

func get_direction():
	var dir = BaseCharacter.position.direction_to(position)
	if dir.x>0:
		if dir.x>abs(dir.y):
			return Vector2.RIGHT
	else:
		if -1*dir.x>abs(dir.y):
			return Vector2.LEFT
	if dir.y>0:
		return Vector2.UP
	else:
		return Vector2.DOWN

func taken_hit(dmg:int):
	$CPUParticles2D.emitting = true
	if not day:
		Active = true
	flash_modulate(Color.RED)
	var tween = create_tween()
	tween.tween_method(flash_shader,0.0,1.0,0.2)
	tween.tween_method(flash_shader,1.0,0.0,0.2)
	Health-=dmg
	if Health<=0:
		Active = false
		PlayerData._enemy_kill_count += 1
		animPlayer.play("Death")
		animPlayer.animation_finished.connect(func(name):queue_free())

func flash_shader(val:float):
	$Sprite2D.material.set_shader_parameter("flashState",val)

func flash_modulate(color:Color):
	var tween = create_tween()
	tween.tween_property(self,"modulate",color,0.3)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
func attack():
	var tween = create_tween()
	tween.tween_property(self,"position",position + BaseCharacter.position.direction_to(position)*10,0.2)
	$Attack.attack_anim(get_direction())
	canAttack = false
	Cooldown = 1/AttackSpeed
	
func day_begins():
	Active = false
	day = true
func night_begins():
	day = false
	if(position.distance_to(BaseCharacter.position)<=BaseCharacter.get_node("ConversionRing/CollisionShape2D").shape.radius):
		Active = true

func activate():
	Active = true
	day = false
