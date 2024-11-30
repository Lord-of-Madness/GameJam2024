extends Node

@onready var nighttheme = $NightStreamPlayer
@onready var daytheme = $DayStreamPlayer
@onready var sound = $SoundPlayer
@onready var rooser = $Rooster
@onready var mining = $Mining
@onready var interact = $Interact
@onready var obtain_resource = $ObtainResource

@export var shutupIamDebugging = false

var is_day: bool = true

func _ready() -> void:
	if not shutupIamDebugging:
		daytheme.play()
	sound.volume_db = 10

func _process(delta: float) -> void:
	if shutupIamDebugging:
		if is_day:
			if daytheme.is_playing():
				daytheme.stop()
			else:
				daytheme.play()
		else:
			if nighttheme.is_playing():
				nighttheme.stop()
			else:
				nighttheme.play()

func swap_music(day: bool):
	is_day = day
	if shutupIamDebugging: return
	var tween = create_tween()
	
	# Night
	if day:
		sound.play()
		tween.tween_property(daytheme,"volume_db",-20,1)
		tween.tween_callback(func(): 
			daytheme.stop()
			nighttheme.play())
		tween.tween_property(nighttheme,"volume_db",0,1)
	# Day
	else:
		rooser.play()
		tween.tween_property(nighttheme,"volume_db",-20,1)
		tween.tween_callback(func(): 
			nighttheme.stop()
			daytheme.play())
		tween.tween_property(daytheme,"volume_db",0,1)
