class_name BloodSplatEnemyHit
extends Node2D

const SELF_SCENE: PackedScene = preload("res://Scenes/Effects/blood_splat_enemy_hit.tscn")
const OFFSET := 4.0
const TRANSITION_DURATION := 2.0

var rng := RandomNumberGenerator.new()
var blood_sprites: Array
var flower_sprites: Array
var sprite_index: int

static func create(target_position: Vector2, direction: Vector2) -> BloodSplatEnemyHit:
	var node: BloodSplatEnemyHit = SELF_SCENE.instantiate()
	Effects.add_child(node)

	node.position = target_position - direction * OFFSET
	node.rotation = direction.angle()

	return node

func _ready() -> void:
	blood_sprites = [$Blood1, $Blood2, $Blood3]
	flower_sprites = [$Flowers1, $Flowers2, $Flowers3]
	sprite_index = rng.randi_range(0, 2)

	var main_game = get_node("/root/Main game")
	main_game.daybegins.connect(_on_daybegins)
	main_game.nightbegins.connect(_on_nightbegins)

	if !main_game.day:
		blood_sprites[sprite_index].modulate.a = 1.0
	else:
		flower_sprites[sprite_index].modulate.a = 1.0

func _on_daybegins():
	var tween := create_tween()
	tween.tween_property(blood_sprites[sprite_index], "modulate", Color.TRANSPARENT, TRANSITION_DURATION)
	tween.parallel().tween_property(flower_sprites[sprite_index], "modulate", Color.WHITE, TRANSITION_DURATION)

func _on_nightbegins():
	var tween := create_tween()
	tween.tween_property(flower_sprites[sprite_index], "modulate", Color.TRANSPARENT, TRANSITION_DURATION)
	tween.parallel().tween_property(blood_sprites[sprite_index], "modulate", Color.WHITE, TRANSITION_DURATION)
