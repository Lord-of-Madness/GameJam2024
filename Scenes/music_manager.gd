extends Node

@onready var nighttheme = $NightStreamPlayer
@onready var daytheme = $DayStreamPlayer

@export var shutupIamDebugging = false

var is_day: bool = true

func _ready() -> void:
	if not shutupIamDebugging:
		daytheme.play()

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
		tween.tween_property(daytheme,"volume_db",-20,1)
		tween.tween_callback(func(): 
			daytheme.stop()
			nighttheme.play())
		tween.tween_property(nighttheme,"volume_db",0,1)
	# Day
	else:
		tween.tween_property(nighttheme,"volume_db",-20,1)
		tween.tween_callback(func(): 
			nighttheme.stop()
			daytheme.play())
		tween.tween_property(daytheme,"volume_db",0,1)
