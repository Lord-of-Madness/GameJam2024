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

var animPlayer:AnimationPlayer
const SPEED = 70.0
var Active = false
func _ready() -> void:
	animPlayer = get_node("Sprite2D/AnimationPlayer")
	animPlayer.play("Idle")



func _process(delta: float) -> void:
	if not canAttack:
		Cooldown-=delta
		if(Cooldown<=0):
			canAttack = true
			
	else:
		if(BaseCharacter.position.distance_to(position)<AttackRange*16):
			attack()
			BaseCharacter.take_damage(damage)
	

func _physics_process(delta: float) -> void:
	if not Active: return
	var target = BaseCharacter.position
	velocity = position.direction_to(target)*SPEED
	move_and_slide()



func attack():
	canAttack = false
	Cooldown = 1/AttackSpeed
