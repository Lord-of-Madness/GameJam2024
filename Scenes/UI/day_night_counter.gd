class_name DayNightCounter
extends Control

var DAY_NIGHT_SWITCH_DURATION := 0.75

var _number := 0
var _day := false

func _ready() -> void:
	$Moon.hide()

func switch_day_night():
	if _number == 0 and !_day:
		#_day = !_day
		return
	
	$RotationCenter/Moon.show()
	$RotationCenter/Sun.show()
	
	var tween := get_tree().create_tween()
	var target_rotation: float = $RotationCenter.rotation + PI / 2.0
	tween.tween_property($RotationCenter, "rotation", target_rotation, DAY_NIGHT_SWITCH_DURATION)
	#tween.tween_callback(_apply_hide)
		
	_day = !_day

#func _apply_hide():
	#if _day:
		#$RotationCenter/Moon.show()
		#$RotationCenter/Sun.hide()
	#else:
		#$RotationCenter/Moon.hide()
		#$RotationCenter/Sun.show()

func increment():
	_number += 1
	on_number_changed()
	
func reset():
	_number = 0
	on_number_changed()
	_day = false
	switch_day_night()
	
func on_number_changed():
	$RotationCenter/Sun/Label.text = str(_number)
	$RotationCenter/Moon/Label.text = str(_number)
	$RotationCenter/Sun2/Label.text = str(_number)
	$RotationCenter/Moon2/Label.text = str(_number)
