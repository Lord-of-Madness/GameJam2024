extends Node2D

const MIN_IDLE_TIME := 3.0
const MAX_IDLE_TIME := 7.0
const MOVEMENT_SPEED := 24.0
# Maximum number of eggs (of all chickens) in the chicken area.
const MAX_EGGS_GLOBAL := 2
# Minimal amount of time during no chicken play another chicken noise after last chicken noise has been played.
const MIN_CHICKEN_NOISE_TIMEOUT := 3.0

static var first_chicken_created := false
static var chicken_noise_timer := MIN_CHICKEN_NOISE_TIMEOUT

var first_chicken := false
var rng := RandomNumberGenerator.new()
var area
var shape: CollisionShape2D
var destination: Vector2
var idle := true
var egg : Node2D = null
var eggs_node: Node2D
var egg_scene

func _ready() -> void:
	egg_scene = preload("res://Scenes/Egg.tscn")
	
	if !first_chicken_created:
		first_chicken = true
		first_chicken_created = true
		
	MusicManager.other_sounds.append($ChickenNoise)
	
func _process(delta: float) -> void:
	if first_chicken:
		chicken_noise_timer += delta
	
	if area == null:
		area = get_parent() as Area2D
		shape = area.get_child(0) as CollisionShape2D
		eggs_node = area.get_node("Eggs")
		position = get_random_pos()
		start_idle()
	
	if idle:
		return
		
	var distance := MOVEMENT_SPEED * delta
	var direction := (destination - position).normalized()
	position += direction * distance
	
	update_facing_direction(direction)
	
	if position.distance_squared_to(destination) <= distance * distance:
		start_idle()

func _on_idle_timer_timeout() -> void:
	start_walk()
	$IdleTimer.stop()
	
func start_idle():
	idle = true
	$AnimatedSprite2D.play("idle_down")
	$IdleTimer.start(rng.randf_range(MIN_IDLE_TIME, MAX_IDLE_TIME))
	
func start_walk(try_lag_egg=true):
	if try_lag_egg:
		try_lay_egg()
	
	destination = get_random_pos()
	idle = false
	
func update_facing_direction(movement_direction: Vector2):
	var directionAngle = movement_direction.angle()
	
	if directionAngle < 0.0:
		directionAngle += 2.0 * PI
	
	if directionAngle <= PI / 4.0 or directionAngle >= 7.0 * PI / 4.0:
		$AnimatedSprite2D.play("walk_right")
	elif directionAngle >= PI / 4.0 and directionAngle <= 3.0 * PI / 4.0:
		$AnimatedSprite2D.play("walk_down")
	elif directionAngle >= 3.0 * PI / 4.0 and directionAngle <= 5.0 * PI / 4.0:
		$AnimatedSprite2D.play("walk_left")
	else:
		$AnimatedSprite2D.play("walk_up")
	
func try_lay_egg():
	if chicken_noise_timer >= MIN_CHICKEN_NOISE_TIMEOUT:
		chicken_noise_timer = 0.0
		$ChickenNoise.play()
	
	if egg != null:
		return
	
	if eggs_node.get_child_count() >= MAX_EGGS_GLOBAL:
		return
		
	egg = egg_scene.instantiate()
	egg.position = position
	eggs_node.add_child(egg)

# Get random position inside parent's shape rectangle.
func get_random_pos() -> Vector2:
	var rect := shape.shape.get_rect()
	var x := rng.randf_range(rect.position.x, rect.position.x + rect.size.x)
	var y := rng.randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	return Vector2(x, y)
