extends Node2D

var Progress:ProgressBar
var Darkness:CanvasLayer
@onready var time:Timer = $Timer
@export_group("Day Night Cycle")
@export var daylenght = 10
@export var nigthlenght = 10
@export_group("Difficulty")
##Max enemies at once on board -1 for no limit
#@export var maxEnemies:int = -1
#var CurrentEnemyNumber = 0
##Number of enemies spawned per second
@export var rarities:Array[float] = [1.0,0.0,0.0]
@export var EnemiesPerSecond:int = 5
@onready var grassShader:Shader = preload("res://Scenes/Grass.gdshader")
@onready var bloodgrassShader:Shader = preload("res://Shaders/BloodGrass.gdshader")
@onready var EnemyScenes:Array[PackedScene] = [
	preload("res://Scenes/enemy.tscn"),
	preload("res://Scenes/Enemies/enemy2.tscn"),
	preload("res://Scenes/Enemies/enemy3.tscn")]

signal daybegins
signal nightbegins

var rng = RandomNumberGenerator.new()

var day = true
var first_day := true

var AvailableTiles:Array[Vector2i]
@onready var GrassMap:TileMapLayer = $Map/TileMaps/GrassLayer
@onready var EvilMap:TileMapLayer = $Map/TileMaps/EvilLayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if first_day:
		$Tutorial.show()
	else:
		$Tutorial.hide()
		
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	PlayerData.reset()
	GrassMap.material.shader = grassShader
	AvailableTiles = GrassMap.get_used_cells()
	var spawnTimer = Timer.new()
	add_child(spawnTimer)
	spawnTimer.timeout.connect(spawn)
	spawnTimer.start()
	
	PlayerData.egg_counter_label = get_node("CanvasLayer/Control/EggCounter/Container/EggCountLabel")
	PlayerData.turnip_counter_label = get_node("CanvasLayer/Control/TurnipCounter/Container/TurnipCountLabel")
	PlayerData.ore_counter_label = get_node("CanvasLayer/Control/OreCounter/Container/OreCountLabel")
	PlayerData.day_night_counter = get_node("CanvasLayer/Control/DayNightCounter")
	
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
	day = true
	day_begins()
	
func revive_player():
	get_tree().paused = true
	PlayerData.is_dead = true
	$CanvasLayer/DeathScreen.show()
	$CanvasLayer/DeathScreen.play_time_string = $CanvasLayer.get_node("Control/Time/Label").text
	$CanvasLayer/DeathScreen.showStats()
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
	%BaseCharacter.collision_mask = %BaseCharacter.collision_mask|0b00001000^0b00001000
	daybegins.emit()
	var twenn = create_tween()
	twenn.tween_property(Progress,"offset_top",-37,1.5)
	twenn.parallel()
	twenn.tween_property(Progress,"offset_bottom",-37,1.5)
	GrassMap.material.shader = grassShader
	twenn.tween_method(
		func(val):$Dark/Control/ColorRect2.material.set_shader_parameter("color",Color(1.0,0.9,0.65,val))
		,0.0,0.23,0.5
		)
	twenn.tween_method(
		func(val):$Dark/Control/ColorRect2.material.set_shader_parameter("color",Color(1.0,0.9,0.65,val))
		,0.23,0.0,1.3
		)
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
	var rect:Rect2 = get_viewport_rect()
	var PlPos = %BaseCharacter.position
	
	for i in range(EnemiesPerSecond):
		
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
		var tilepos:Vector2i = GrassMap.local_to_map(GrassMap.to_local(newPos))
		var tiledata:TileData = GrassMap.get_cell_tile_data(tilepos)
		
		if(tiledata and GrassMap.get_cell_atlas_coords(tilepos)==Vector2i(1,1)):
			rarities[0] = max(0.0,1.0-rarities[1]/2)
			rarities[1] = min(2.0,PlayerData.day_night_counter._number/10.0)
			rarities[2] = min(2.0,PlayerData._enemy_kill_count/100.0)
			var enemy:Enemy = EnemyScenes[rng.rand_weighted(PackedFloat32Array(rarities))].instantiate()
			enemy.position = newPos
			add_child(enemy)
			enemy.activate()
			#CurrentEnemyNumber+=1

func _on_nightbegins() -> void:
	PlayerData.apply_damage_upgrade()
	PlayerData.apply_HP_upgrade()
	PlayerData.apply_movement_speed_upgrade()
	PlayerData.apply_enemy_hp_upgrade()
	
	PlayerData.player.Health = PlayerData.player.MaxHP
	PlayerData.player.health_change.emit()
	
	PlayerData.day_night_counter.switch_day_night()


func _on_daybegins() -> void:
	if !first_day:
		PlayerData.elapsed_nights += 1
		
	PlayerData.day_night_counter.switch_day_night()
	PlayerData.day_night_counter.increment()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($Tutorial, "modulate", Color(1.0,1.0,1.0,0.0), 8.0)
	
	first_day = false
