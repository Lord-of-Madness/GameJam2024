extends CharacterBody2D
class_name Enemy


@export_group("GameProperties")
@export_range(0,100,5,"or_greater") var Health:int = 10
@export_subgroup("Combat Properties")
##Attacks per Second
@export var AttackSpeed : float= 1.0
##Attacks range in tiles
@export var AttackRange : int= 1
##Damage dealt
@export var damage : int= 1
var day = true
var canAttack:bool  = true
var Cooldown:float = 0

@onready var AttackNode:Attack = get_node("Attack")

var animPlayer:AnimationPlayer
const SPEED = 70.0
var Active = false
func _ready() -> void:
	animPlayer = get_node("Sprite2D/AnimationPlayer")
	animPlayer.play("Idle")
	%BaseCharacter.death_signal.connect(func():Active = false)
	get_parent().connect("daybegins",day_begins)
	get_parent().connect("nightbegins",night_begins)

func _process(delta: float) -> void:
	if not canAttack:
		Cooldown-=delta
		if(Cooldown<=0):
			canAttack = true
			
	elif Active:
		if(%BaseCharacter.position.distance_to(position)<AttackRange*16):
			attack()
			%BaseCharacter.take_damage(damage)

func _physics_process(delta: float) -> void:
	if not Active: return
	var target = %BaseCharacter.position
	velocity = position.direction_to(target)*SPEED
	move_and_slide()

func get_direction():
	var dir = %BaseCharacter.position.direction_to(position)
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
	if not day:
		Active = true
	flash_modulate(Color.RED)
	Health-=dmg
	if Health<=0:
		queue_free()
func flash_modulate(color:Color):
	var tween = create_tween()
	tween.tween_property(self,"modulate",color,0.3)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
func attack():
	var tween = create_tween()
	tween.tween_property(self,"position",position + %BaseCharacter.position.direction_to(position)*10,0.2)
	$Attack.attack_anim(get_direction())
	canAttack = false
	Cooldown = 1/AttackSpeed
	
func day_begins():
	$DaySprite.visible = true
	$Sprite2D.visible = false
	Active = false
	day = true
func night_begins():
	day = false
	$DaySprite.visible = false
	$Sprite2D.visible = true
	if(position.distance_to(%BaseCharacter.position)<=%BaseCharacter.get_node("ConversionRing/CollisionShape2D").shape.radius):
		Active = true
