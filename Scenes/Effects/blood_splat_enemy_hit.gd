class_name BloodSplatEnemyHit
extends Node2D

const SELF_SCENE: PackedScene = preload("res://Scenes/Effects/blood_splat_enemy_hit.tscn")
const OFFSET := 4.0

var rng := RandomNumberGenerator.new()

static func create(target_position: Vector2, direction: Vector2) -> BloodSplatEnemyHit:
	var node: BloodSplatEnemyHit = SELF_SCENE.instantiate()
	Effects.add_child(node)

	node.position = target_position - direction * OFFSET
	node.rotation = direction.angle()

	return node

func _ready() -> void:
	var sprites := [$Sprite1, $Sprite2, $Sprite3, $Sprite4]
	var sprite_index := rng.randi_range(0, 3)
	sprites[sprite_index].show()
