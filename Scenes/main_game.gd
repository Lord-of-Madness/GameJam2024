extends Node2D

var Progress:ProgressBar
@onready var time:Timer = $Timer
@export var daylenght = 10
@export var nigthlenght = 10
@onready var nighttheme = $NightStreamPlayer
@onready var daytheme = $DayStreamPlayer
@export var shutupIamDebugging = false

var day = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progress = $CanvasLayer.get_node("Control/ProgressBar")
	Progress.base_character = %BaseCharacter
	%BaseCharacter.position = $SpawnPoint.position
	%BaseCharacter.death_signal.connect(revive_player)
	Progress.offset_top = -37
	Progress.offset_bottom = -37
	time.wait_time = daylenght
	time.timeout.connect(swapCycle)
	time.start()
	if not shutupIamDebugging:
		daytheme.play()

func revive_player():
	%BaseCharacter.position = $SpawnPoint.position

func night_begins():
	if not shutupIamDebugging:
		var tween = create_tween()
		tween.tween_property(daytheme,"volume_db",-20,1)
		tween.tween_callback(func(): 
			daytheme.stop()
			nighttheme.play())
		tween.tween_property(nighttheme,"volume_db",0,1)
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",7,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",7,1.5)
	twenn.parallel()
	
	
	
func day_begins():
	if not shutupIamDebugging:
		var tween = create_tween()
		tween.tween_property(nighttheme,"volume_db",-20,1)
		tween.tween_callback(func(): 
			nighttheme.stop()
			daytheme.play())
		tween.tween_property(daytheme,"volume_db",0,1)
	
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",-37,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",-37,1.5)
	
func swapCycle():
	get_node("CanvasLayer/Control/CycleAnnouncement").change_text(!day)
	if day:
		day = false
		night_begins()
	else:
		day = true
		day_begins()
