extends RigidBody2D
class_name Bullet
@export_range(0, 100, 1,"or_greater") var speed:float = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func launch(pos:Vector2,rot:float):
	position = pos - Vector2.from_angle(rot)*24
	rotation = rot
	linear_velocity = Vector2.from_angle(rot)*-speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.distance_to(get_node("../BaseCharacter").position)>300:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body is Player or body is Bullet:
		return
	if body is Enemy:
		body.taken_hit()
	queue_free()
