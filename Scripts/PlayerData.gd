extends Node

var _egg_count := 0
var _ore_count := 0
var _turnip_count := 0

var egg_counter_label: Label
var turnip_counter_label: Label
var ore_counter_label: Label
var is_night := false
var in_mechanic := false
var player:Player

func increment_egg_count():
	_egg_count += 1
	on_egg_count_changed()
	
func reset_egg_count():
	_egg_count = 0
	on_egg_count_changed()
	
func on_egg_count_changed():
	egg_counter_label.text = str(_egg_count)
	MusicManager.obtain_resource.play()
	
func increment_ore_count():
	_ore_count += 1
	on_ore_count_changed()
	
func reset_ore_count():
	_ore_count = 0
	on_ore_count_changed()
	
func on_ore_count_changed():
	ore_counter_label.text = str(_ore_count)
	MusicManager.obtain_resource.play()
	
func increment_turnip_count():
	_turnip_count += 1
	on_turnip_count_changed()

func on_turnip_count_changed():
	turnip_counter_label.text = str(_turnip_count)
	MusicManager.obtain_resource.play()

func reset_turnip_count():
	_turnip_count = 0
	on_turnip_count_changed()
	
