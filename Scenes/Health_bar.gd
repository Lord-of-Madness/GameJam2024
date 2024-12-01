extends ProgressBar

const BLOOD_OVERLAY_THRESHOLD := 0.25

var base_character: Node2D
var first_frame := true

func _process(delta: float) -> void:
	if first_frame:
		first_frame = false
		base_character.health_change.connect(change_hp)
		max_value = base_character.MaxHP
		value = base_character.Health

func change_hp():
	value = base_character.Health
	
	if value / base_character.MaxHP <= BLOOD_OVERLAY_THRESHOLD:
		$"../BloodOverlay".show()
	else:
		$"../BloodOverlay".hide()
