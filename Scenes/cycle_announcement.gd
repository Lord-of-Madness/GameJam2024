extends Control

@onready var glitch:Label = $Label
@onready var text:Label = $Label2
@onready var bloody:LabelSettings = preload("res://Scenes/LabelData/Bloody_Label.tres")
@onready var nice:LabelSettings = preload("res://Scenes/LabelData/Pretty_Label.tres")

var night_text = "With the setting sun
EVERYTHING CHANGES
Night begins!"

var day_text = "With the rising sun
Everything changes
Day begins!"

func _ready() -> void:
	glitch.modulate = Color(1,1,1,0)
	text.modulate = Color(1,1,1,0)
	glitch.text = night_text


func change_text(day:bool):
	if day:
		text.text = day_text
		text.label_settings = nice
		glitch.visible = false
	else:
		text.text = night_text
		text.label_settings = bloody
		glitch.visible = true
		
	var tween = create_tween()
	tween.tween_property(glitch,"modulate",Color.WHITE,0.4)
	tween.parallel()
	tween.tween_property(text,"modulate",Color.WHITE,0.4)
	tween.tween_property(text,"modulate",Color.WHITE,2)#Essentially wait
	tween.tween_property(glitch,"modulate",Color(1,1,1,0),0.4)
	tween.parallel()
	tween.tween_property(text,"modulate",Color(1,1,1,0),0.4)
	
