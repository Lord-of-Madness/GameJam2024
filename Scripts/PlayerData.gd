extends Node

# Increase of damage per ore piece (One Piece is real).
const DAMAGE_INC := 0.2
# Increase of HP per turnip.
const HP_INC := 1.0
# Increase of movement speed per egg.
const MOVEMENT_SPEED_INC := 1.0

# Increases of enemy max HP per day-night cycle.
const ENEMY_HP_INC := 0.5

# Amount of eggs player has picked up during day.
var _egg_count := 0
# Amount of ore pieces player has mined during day.
var _ore_count := 0
# Amount of turnips player has harvested during day.
var _turnip_count := 0

# Amount of killed enemies
var _enemy_kill_count := 0

var _max_turnip_count := 0

var _max_eggs_count := 0

var _max_ore_count := 0

var egg_counter_label: Label
var turnip_counter_label: Label
var ore_counter_label: Label
var day_night_counter: DayNightCounter

# Determine if night is currently active.
var is_night := false
# Determine if player is currenty inside some mechanic (for example ore mining mechanic).
var in_mechanic := false
var player:Player

var is_dead: bool = false

var second_life: bool = false
var used_life: bool = false

# Current bonus to player's bullet damage.
var bullet_damage_bonus := 0.0
# Current bonus to player's max HP amount. 
var max_hp_bonus := 0.0
# Current bonus to player's movement speed.
var movement_speed_bonus := 0.0
# Current bonus to enemy max HP.
var enemy_max_hp_bonus := 0.0

# Number of elapsed nights since the last start of game scene.
var elapsed_nights := 0

# Resets all player data.
func reset():
	bullet_damage_bonus = 0.0
	max_hp_bonus = 0.0
	movement_speed_bonus = 0.0
	enemy_max_hp_bonus = 0.0
	is_night = false
	in_mechanic = false
	elapsed_nights = 0
	second_life = false
	used_life = false
	
	_enemy_kill_count = 0
	_max_turnip_count = 0
	_max_eggs_count = 0
	_max_ore_count = 0
	
	if day_night_counter != null:
		day_night_counter.reset()

# Increases enemy max HP bonus.
func apply_enemy_hp_upgrade():
	enemy_max_hp_bonus += ENEMY_HP_INC;

# Increases damage bonus and resets ore piece count.
func apply_damage_upgrade():
	bullet_damage_bonus += DAMAGE_INC * _ore_count
	reset_ore_count()
	player.try_upgrade_gun()
	
# Increases HP bonus and resets egg count.
func apply_HP_upgrade():
	var max_hp_increase := HP_INC * _egg_count
	player.MaxHP += max_hp_increase
	player.health_change.emit()
	max_hp_bonus += max_hp_increase
	_max_eggs_count += _egg_count
	reset_egg_count()
	
# Increases movement speed bonus and resets turnip count.
func apply_movement_speed_upgrade():
	movement_speed_bonus += MOVEMENT_SPEED_INC * _turnip_count
	_max_turnip_count += _turnip_count
	reset_turnip_count()

func increment_egg_count():
	_egg_count += 1
	on_egg_count_changed()
	MusicManager.obtain_resource.play()
	
func reset_egg_count():
	_egg_count = 0
	on_egg_count_changed()
	
func on_egg_count_changed():
	egg_counter_label.text = str(_egg_count)
	
func increment_ore_count():
	_ore_count += 1
	on_ore_count_changed()
	MusicManager.obtain_resource.play()
	
func reset_ore_count():
	_ore_count = 0
	on_ore_count_changed()
	
func on_ore_count_changed():
	ore_counter_label.text = str(_ore_count)
	
func increment_turnip_count():
	_turnip_count += 1
	on_turnip_count_changed()
	MusicManager.obtain_resource.play()

func on_turnip_count_changed():
	turnip_counter_label.text = str(_turnip_count)

func reset_turnip_count():
	_turnip_count = 0
	on_turnip_count_changed()
	
