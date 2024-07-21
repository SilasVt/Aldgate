extends Area2D

static var health := 100
static var dead := false
static var shield_equipped := false
static var equipped_shield_element := "FIRE"
var incoming_element := "none"
static var direction
var shield_active = true


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
	
	
	
func _process(_delta):
	var direction_t = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	if direction_t != Vector2(0, 0):
		direction = direction_t
	
	if Input.is_action_pressed("shield_action"):
		shield_active = true
		match equipped_shield_element:	
			"FIRE":
				handle_fire_shield(shield_active)
			#"water":
			#	handle_water_state()
			#"ice":
			#	handle_ice_state()
			#"wind":
			#	handle_wind_state()
			_:
				print("unmatched")
			



func handle_fire_shield(shield_active):
	if shield_active:
		fire_shield.set_active(true)
		fire_shield.set_direction(direction)
	else:
		fire_shield.set_active(false)
