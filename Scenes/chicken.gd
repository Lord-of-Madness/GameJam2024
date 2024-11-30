extends Node2D

const MIN_IDLE_TIME := 3.0
const MAX_IDLE_TIME := 10.0
const MOVEMENT_SPEED := 16.0
# Maximum number of eggs (of all chickens) in the chicken area.
const MAX_EGGS_GLOBAL := 2

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

func _process(delta: float) -> void:
	if area == null:
		area = get_parent() as Area2D
		shape = area.get_child(0) as CollisionShape2D
		eggs_node = area.get_node("Eggs")
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
	
func start_walk():
	try_lay_egg()
	
	var rect := shape.shape.get_rect()
	var x := rng.randf_range(rect.position.x, rect.position.x + rect.size.x)
	var y := rng.randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	destination = Vector2(x, y)
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
	if egg != null:
		return
	
	if eggs_node.get_child_count() >= MAX_EGGS_GLOBAL:
		return
		
	egg = egg_scene.instantiate()
	egg.position = position
	eggs_node.add_child(egg)
