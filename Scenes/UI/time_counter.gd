extends Control

const SECONDS_IN_MINUTE := 60

var elapsed_seconds := 0.0

func _process(delta: float) -> void:
	elapsed_seconds += delta
	
	var minutes := int(elapsed_seconds) / SECONDS_IN_MINUTE
	var seconds := int(elapsed_seconds) % SECONDS_IN_MINUTE
	$Label.text = ("%02d" % minutes) + ':' + ("%02d" % seconds)
