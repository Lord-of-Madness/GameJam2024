class_name DayNightCounter
extends Control

var _number := 0
var _day := false

func _ready() -> void:
	$Moon.hide()

func switch_day_night():
	if _day:
		$Moon.show()
		$Sun.hide()
	else:
		$Moon.hide()
		$Sun.show()
		
	_day = !_day

func increment():
	_number += 1
	on_number_changed()
	
func reset():
	_number = 0
	on_number_changed()
	_day = false
	switch_day_night()
	
func on_number_changed():
	$Label.text = str(_number)
