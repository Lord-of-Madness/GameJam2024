class_name MinihMechanic
extends Node2D

const SPEED := 300.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var direction := 1.0
var max_x: float
var middle_x: float

func _ready() -> void:
	max_x = $Background.size.x - $Background/HitBox.size.x
	middle_x = $Background.size.x / 2.0
	PlayerData.in_mechanic = true
	
	$Background/HitBox.position.x = rng.randf_range(0.0, max_x)
	direction = 1.0 if rng.randf() <= 0.5 else -1.0

func _process(delta: float) -> void:
	$Background/HitBox.position.x += SPEED * delta * direction
	
	if $Background/HitBox.position.x > max_x:
		direction = -1.0
		$Background/HitBox.position.x = max_x
	elif $Background/HitBox.position.x < 0.0:
		direction = 1.0
		$Background/HitBox.position.x = 0.0
		
	if Input.is_action_just_pressed("interact"):
		if $Background/HitBox.get_rect().intersects($Background/Target.get_rect(), true):
			PlayerData.increment_ore_count()
			RewardEffect.new_ore()
			PlayerData._max_ore_count += 1
		else:
			on_fail()
		PlayerData.in_mechanic = false
		queue_free()

func on_fail():
	MusicManager.fail_mining.play()
	PlayerData.player.camera_shake(Vector2.ZERO, 0.35, 8.0)
