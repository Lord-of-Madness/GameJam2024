# Represent an effect in which resource item icon spawns in the middle of the screen and then it
# travels to the resource counters area. Effects moves in screen space.
class_name RewardEffect
extends Node2D

const SELF_SCENE: PackedScene = preload("res://Scenes/Effects/reward_effect.tscn")
# Duration of effect.
const DURATION := 0.7
# Positive relative to the spawn position. Icon will move towards this position.
const OFFSET := Vector2(-1920.0, 1060.0) / 2.0

# Create new effect for egg resource.
static func new_egg() -> RewardEffect:
	var node: RewardEffect = SELF_SCENE.instantiate()
	Effects.add_child(node)
	node.get_node("Egg").show()
	
	return node
	
# Create new effect for egg resource.
static func new_turnip() -> RewardEffect:
	var node: RewardEffect = SELF_SCENE.instantiate()
	Effects.add_child(node)
	node.get_node("Turnip").show()
	
	return node
	
# Create new effect for egg resource.
static func new_ore() -> RewardEffect:
	var node: RewardEffect = SELF_SCENE.instantiate()
	Effects.add_child(node)
	node.get_node("Ore").show()
	
	return node
	
func _ready() -> void:
	position = PlayerData.player.position
	_start_position_tween()

# Start tween of effect's position.
func _start_position_tween():
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", position + OFFSET, DURATION)
	tween.tween_callback(_on_tween_complete)
	
func _on_tween_complete():
	queue_free()
