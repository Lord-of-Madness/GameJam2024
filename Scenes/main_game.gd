extends Node2D

var Progress:ProgressBar
@onready var time:Timer = $Timer
@export var daylenght = 10
@export var nigthlenght = 10

var day = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progress = get_node("CanvasLayer/Control/ProgressBar")
	%BaseCharacter.position = $SpawnPoint.position
	%BaseCharacter.death_signal.connect(revive_player)
	Progress.offset_top = -37
	Progress.offset_bottom = -37
	time.wait_time = daylenght
	time.timeout.connect(swapCycle)
	time.start()
	

func revive_player():
	%BaseCharacter.position = $SpawnPoint.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func night_begins():
	
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",7,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",7,1.5)
	twenn.parallel()
	
	
	
func day_begins():
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",-37,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",-37,1.5)
	
func swapCycle():
	get_node("CanvasLayer/Control/CycleAnnouncement").change_text(!day)
	if day:
		day = false
		night_begins()
	else:
		day = true
		day_begins()
