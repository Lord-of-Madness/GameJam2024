extends Node2D

var Progress:ProgressBar
var Darkness:CanvasLayer
@onready var time:Timer = $Timer
@export var daylenght = 10
@export var nigthlenght = 10

@onready var grassShader:Shader = preload("res://Scenes/Grass.gdshader")
@onready var bloodgrassShader:Shader = preload("res://Shaders/BloodGrass.gdshader")

var day = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.egg_counter_label = get_node("CanvasLayer/Control/EggCounter/Container/EggCountLabel")
	PlayerData.turnip_counter_label = get_node("CanvasLayer/Control/TurnipCounter/Container/TurnipCountLabel")
	Progress = get_node("CanvasLayer/Control/ProgressBar")
	Progress.base_character = %BaseCharacter
	Darkness = get_node("Dark")
	%BaseCharacter.position = $SpawnPoint.position
	%BaseCharacter.death_signal.connect(revive_player)
	Progress.offset_top = -37
	Progress.offset_bottom = -37
	time.wait_time = daylenght
	time.timeout.connect(swapCycle)
	time.start()

func revive_player():
	%BaseCharacter.position = $SpawnPoint.position

func night_begins():
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",7,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",7,1.5)
	
	# Night fades in
	$Dark.get_node("AnimationPlayer").play("fade")
	get_node("Map/TileMaps/GrassLayer").material.shader = bloodgrassShader
	
	
	
func day_begins():	
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",-37,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",-37,1.5)
	get_node("Map/TileMaps/GrassLayer").material.shader = grassShader
	
	# Night fades away
	$Dark.get_node("AnimationPlayer").play_backwards("fade")
	
func swapCycle():
	get_node("CanvasLayer/Control/CycleAnnouncement").change_text(!day)
	MusicManager.swap_music(day)
	if day:
		day = false
		night_begins()
	else:
		day = true
		day_begins()
