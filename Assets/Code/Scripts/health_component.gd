extends Node2D
class_name HealthComponent

@export var default_health := 100
@export var max_health := 100
@export var critical_health_level := 100

@export var fire_damage_multiplier := 1.0
@export var water_damage_multiplier := 1.0
@export var earth_damage_multiplier := 1.0
@export var wind_damage_multiplier := 1.0

signal health_zero()
signal health_critical()
signal health_max()
signal health_default()

var health := 0
var dead = false

func get_health():
	return health

func set_health(new_health):
	health = new_health
	check_health_signals()
	
func reset_health():
	health = default_health
	check_health_signals()


#Element names in CONSTCASE, element type doesn't change for items, enemies, weapons, etc.
func set_multiplier(element, value):
	match element:
		"FIRE":
			fire_damage_multiplier = value
		"WATER":
			water_damage_multiplier = value
		"EARTH":
			earth_damage_multiplier = value
		"WIND":
			wind_damage_multiplier = value
		
func get_multiplier(element):
	match element:
		"FIRE":
			return fire_damage_multiplier
		"WATER":
			return water_damage_multiplier
		"EARTH":
			return earth_damage_multiplier
		"WIND":
			return wind_damage_multiplier
			
func damage(element, amount):
	match element:
		"FIRE":
			health -= amount * fire_damage_multiplier
		"WATER":
			health -= amount * water_damage_multiplier
		"EARTH":
			health -= amount * earth_damage_multiplier
		"WIND":
			health -= amount * wind_damage_multiplier
		_:
			health -= amount
			
	check_health_signals()
	
	
func add_health(addition):
	health += addition
	check_health_signals()

func remove_health(subtraction):
	health -= subtraction
	check_health_signals()

# Called when the node enters the scene tree for the first time.
func _ready():
	health = default_health

func check_health_signals():
	if health <= 0:
		health_zero.emit()
	if health <= critical_health_level:
		health_critical.emit()
	if health == max_health:
		health_max.emit()
	if health == default_health:
		health_default.emit()
		
func _process(delta):
	if health <= 0:
		dead = true
	else:
		dead = false
