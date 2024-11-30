extends Node2D

var Progress:ProgressBar
var Darkness:CanvasLayer
@onready var time:Timer = $Timer
@export var daylenght = 10
@export var nigthlenght = 10

@onready var grassShader:Shader = preload("res://Scenes/Grass.gdshader")
@onready var bloodgrassShader:Shader = preload("res://Shaders/BloodGrass.gdshader")
@onready var CadaverScene = preload("res://Scenes/enemy.tscn")

signal daybegins
signal nightbegins

var rng = RandomNumberGenerator.new()

var day = true

var AvailableTiles:Array[Vector2i]
@onready var GrassMap:TileMapLayer = $Map/TileMaps/GrassLayer
@onready var EvilMap:TileMapLayer = $Map/TileMaps/EvilLayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AvailableTiles = GrassMap.get_used_cells()
	var spawnTimer = Timer.new()
	add_child(spawnTimer)
	spawnTimer.timeout.connect(spawn)
	spawnTimer.start()
	
	PlayerData.egg_counter_label = get_node("CanvasLayer/Control/EggCounter/Container/EggCountLabel")
	PlayerData.turnip_counter_label = get_node("CanvasLayer/Control/TurnipCounter/Container/TurnipCountLabel")
	PlayerData.ore_counter_label = get_node("CanvasLayer/Control/OreCounter/Container/OreCountLabel")
	PlayerData.player = %BaseCharacter
	InteractionManager.player = %BaseCharacter
	Progress = get_node("CanvasLayer/Control/ProgressBar")
	Progress.base_character = %BaseCharacter
	Darkness = get_node("Dark")
	%BaseCharacter.position = $SpawnPoint.position
	%BaseCharacter.death_signal.connect(revive_player)
	Progress.offset_top = -37
	Progress.offset_bottom = -37
	time.wait_time = daylenght
	time.timeout.connect(swapCycle)
	time.start()

func revive_player():
	%BaseCharacter.position = $SpawnPoint.position

func night_begins():
	EvilMap.visible = true
	PlayerData.is_night = true
	%BaseCharacter.collision_mask = %BaseCharacter.collision_mask|0b00001000
	nightbegins.emit()
	var twenn = create_tween()
	
	twenn.tween_property(Progress,"offset_top",7,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",7,1.5)
	
	# Night fades in
	$Dark.get_node("AnimationPlayer").play("fade")
	get_node("Map/TileMaps/GrassLayer").material.shader = bloodgrassShader
	
	
func day_begins():
	EvilMap.visible = false
	PlayerData.is_night = false
	%BaseCharacter.collision_mask = %BaseCharacter.collision_mask^0b00001000
	daybegins.emit()
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",-37,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",-37,1.5)
	GrassMap.material.shader = grassShader
	
	# Night fades away
	$Dark.get_node("AnimationPlayer").play_backwards("fade")
	
func swapCycle():
	get_node("CanvasLayer/Control/CycleAnnouncement").change_text(!day)
	MusicManager.swap_music(day)
	if day:
		day = false
		night_begins()
	else:
		day = true
		day_begins()

func spawn():
	if day: return
	var toSpawn = 5
	var rect:Rect2 = get_viewport_rect()
	var PlPos = %BaseCharacter.position
	for i in range(toSpawn):
		
		var newPos:Vector2
		var sector = randi_range(0,3)
		var rx:float
		var ry:float
		var l = PlPos.x-rect.size.x/2
		var r = PlPos.x+rect.size.x/2
		var t = PlPos.y+rect.size.y/2
		var b = PlPos.y-rect.size.y/2
		match sector:
			0:#left
				rx = rng.randf_range(l-10,l)
				ry = rng.randf_range(b -10,t +10)
				newPos = Vector2(rx,ry)
			1:#right
				rx = rng.randf_range(r,r+10)
				ry = rng.randf_range(b -10,t +10)
				newPos = Vector2(rx,ry)
			2:#top
				rx = rng.randf_range(l-10,r+10)
				ry = rng.randf_range(t,t +10)
				newPos = Vector2(rx,ry)
			3:#top
				rx = rng.randf_range(l-10,r+10)
				ry = rng.randf_range(b-10,b)
				newPos = Vector2(rx,ry)
		var tiledata:TileData = GrassMap.get_cell_tile_data(GrassMap.local_to_map(newPos))
		
		if(tiledata):
			print(GrassMap.local_to_map(newPos)-GrassMap.local_to_map(PlPos))
			var enemy:Enemy = CadaverScene.instantiate()
			enemy.position = newPos- newPos.direction_to(PlPos)
			add_child(enemy)
			enemy.activate()
