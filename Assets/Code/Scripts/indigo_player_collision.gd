extends Area2D

static var health := 100
static var dead := false
static var shield_equipped := false
static var equipped_shield_element := "FIRE"
var incoming_element := "none"
static var direction
var shield_active = false
static var shield_select


@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var death_sound = $DeathSound
@onready var fire_shield = $FireShield

func _on_area_entered(area):
	if !area.has_method("get_current_attack_damage") or !area.is_in_group("attacking"):
		return
	
	if area.has_method("get_element"):
		incoming_element = area.get_element()
		
	var blocking = Input.is_action_pressed("blocking")
	
	if (incoming_element == equipped_shield_element) and shield_equipped and blocking:
		print("Attack Blocked")
		#Play Block Sound and animation
		return
		
	elif (incoming_element != equipped_shield_element) and shield_equipped and blocking:
		print("Attack Blocked")
		print("Shield Broke")
		return

	if shield_equipped and blocking:
		#Play Block Sound
		print("Attack Blocked")
		return
	else:
		var damage = area.get_current_attack_damage()
		
		health -= damage
	
	if health <= 0:
		dead = true
		death_sound.play()
	
func _ready():
	pass
	#print ("Set Shield")
	#fire_shield.set_direction(Vector2 (0,0))
	
func _process(_delta):
	
	#1 for fire, 2 for water, 3 for earth, 4 for wind
	shield_select = Vector2(Input.get_axis("shield_1", "shield_2"), Input.get_axis("shield_3", "shield_4")).normalized()
	match shield_select:
		Vector2(-1, 0):
			equipped_shield_element = "FIRE"
			fire_shield.select_shield(true)
			#water_shield.select_shield(false)
			#earth_shield.select_shield(false)
			#wind_shield.select_shield(false)
			print("FIRE")
		Vector2(1, 0):
			equipped_shield_element = "WATER"
			#fire_shield.select_shield(true)
			#earth_shield.select_shield(false)
			#wind_shield.select_shield(false)
			print("WATER")
		Vector2(0, -1):
			equipped_shield_element = "EARTH"
			#water_shield.select_shield(true)
			#fire_shield.select_shield(false)
			#wind_shield.select_shield(false)
			print("EARTH")
		Vector2(0, 1):
			equipped_shield_element = "WIND"
			#wind_shield.select_shield(true)
			print("WIND")
	
	
	#Get and set Directional Info for shield/weapons. Run always
	var direction_t = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	if direction_t != Vector2(0, 0):
		direction = direction_t
	#fire_shield.set_direction(direction)
	#water_shield.set_direction(direction)
	#earth_shield.set_direction(direction)
	#wind_shield.set_direction(direction)
	
func shield_elements_off():
	fire_shield.set_active(false)

func handle_fire_shield():
		fire_shield.set_active(true)
		

