extends CharacterBody2D
class_name Enemy


@export_group("GameProperties")
@export_subgroup("Combat Properties")
##Attacks per Second
@export var AttackSpeed : float= 1.0
##Attacks range in tiles
@export var AttackRange : int= 1
##Damage dealt
@export var damage : int= 1

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
	



func _process(delta: float) -> void:
	if not canAttack:
		Cooldown-=delta
		if(Cooldown<=0):
			canAttack = true
			
	else:
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


func attack():
	var tween = create_tween()
	tween.tween_property(self,"position",position + %BaseCharacter.position.direction_to(position)*10,0.2)
	$Attack.attack_anim(get_direction())
	canAttack = false
	Cooldown = 1/AttackSpeed
