extends Node

@onready var nighttheme: AudioStreamPlayer = $NightStreamPlayer
@onready var daytheme: AudioStreamPlayer = $DayStreamPlayer
@onready var sound: AudioStreamPlayer = $SoundPlayer
@onready var rooser: AudioStreamPlayer = $Rooster
@onready var mining: AudioStreamPlayer = $Mining
@onready var interact: AudioStreamPlayer = $Interact
@onready var obtain_resource: AudioStreamPlayer = $ObtainResource
@onready var fail_mining: AudioStreamPlayer = $FailMining

@export var shutupIamDebugging = false

var other_sounds = []

var is_day: bool = true

func _ready() -> void:
	if not shutupIamDebugging and not daytheme.is_playing():
		daytheme.play()
	sound.volume_db = 10

func _process(delta: float) -> void:
	if shutupIamDebugging:
		if daytheme.is_playing():
			daytheme.stop()
		elif nighttheme.is_playing():
			nighttheme.stop()

func swap_music(day: bool, low_hp := false):
	is_day = day
	if shutupIamDebugging: return
	var tween = create_tween()
	
	if low_hp:
		tween.tween_property(nighttheme, "pitch_scale", 1.2, 1.0)
		tween.parallel().tween_property(nighttheme, "volume_db", 10.0, 1.0)
		return
	
	# Night
	if day:
		sound.play()
		tween.tween_property(daytheme, "volume_db", -20.0, 1.0)
		tween.parallel().tween_property(daytheme, "pitch_scale", 1.0, 0.1)
		tween.tween_callback(func(): 
			daytheme.stop()
			nighttheme.play())
		tween.tween_property(nighttheme, "volume_db", 0.0, 1.0)
		tween.parallel().tween_property(nighttheme, "pitch_scale", 1.0, 0.1)
	# Day
	else:
		rooser.play()
		tween.tween_property(nighttheme, "volume_db", -20.0, 1.0)
		tween.parallel().tween_property(nighttheme, "pitch_scale", 1.0, 0.1)
		tween.tween_callback(func(): 
			nighttheme.stop()
			daytheme.play())
		tween.tween_property(daytheme, "volume_db", 0,1)
		tween.parallel().tween_property(daytheme, "pitch_scale", 1.0, 0.1)
		
func reset_music():
	if nighttheme.is_playing():
		var tween = create_tween()
		tween.tween_callback(func(): 
			nighttheme.stop()
			daytheme.play())
		tween.tween_property(daytheme,"volume_db",0,1)
		tween.tween_property(nighttheme, "pitch_scale", 1.0, 1.0)
		return
	if not daytheme.is_playing():
		daytheme.play()
		
func mute():
	if shutupIamDebugging:
		shutupIamDebugging = false
		reset_music()
	else:
		shutupIamDebugging = true
		
