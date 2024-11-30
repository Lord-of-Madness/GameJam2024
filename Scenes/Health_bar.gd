extends ProgressBar


func _ready() -> void:
	%BaseCharacter.health_change.connect(change_hp)
	max_value = %BaseCharacter.MaxHP
	value = %BaseCharacter.Health


func change_hp():
	value = %BaseCharacter.Health
