extends Node

var _egg_count := 0
var _ore_count := 0

var egg_counter_label: Label

func increment_egg_count():
	_egg_count += 1
	on_egg_count_changed()
	
func reset_egg_count():
	_egg_count = 0
	on_egg_count_changed()
	
func on_egg_count_changed():
	egg_counter_label.text = str(_egg_count)
	
func increment_ore_count():
	_ore_count += 1
	on_ore_count_changed()
	
func reset_ore_count():
	_ore_count = 0
	on_ore_count_changed()
	
func on_ore_count_changed():
	pass
