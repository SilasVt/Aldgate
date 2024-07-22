extends Node2D


const TYPE := "SHIELD"

static var shield_element := "none"
var degrees := 0
static var shield_durability := 3
static var default_durability := 3
var shield_in_use := false

func get_type():
	return TYPE

func set_direction(new_direction):
	#Calculate Direction for raycast
	# Get the angle in radians between the direction vector and the positive x-axis
	# Convert the angle from radians to degrees
	# Normalize the angle to be between 0 and 360 degrees
	if new_direction == null:
		return
		
	var radians = atan2(new_direction.y, new_direction.x)
	degrees = radians * 180 / PI
	if degrees < 0:
		degrees += 360
		

func get_shield_angle():
	#Return animation, shield sprite z priority, particles z priority.
	if degrees < 22 or degrees > 337:
		return ["right", 3, 2]
	if degrees > 202 and degrees < 247:
		return ["up_left", 3, 2]
	if degrees > 247 and degrees < 292:
		return ["up", 3, 2]
	if degrees > 292 and degrees < 337:
		return ["up_right", 3, 2]
	if degrees > 157 and degrees < 202:
		return ["left", 3, 2]
	if degrees > 112 and degrees < 157:
		return ["down_left", 6, 7]
	if degrees > 68 and degrees < 112:
		return ["down", 6, 7]
	if degrees > 22 and degrees < 67:
		return ["down_right", 6, 7]
	#animated_sprite_2d.play()
	
func select_shield(new_selection):
	print(shield_element)
	if new_selection != shield_element:
		disable_shield()
		shield_in_use = false
		
	elif new_selection == shield_element:
		
		if shield_durability <= 0:
			#fail_sound.play()
			return
		enable_shield()

		
func enable_shield():
	if !shield_in_use:
		shield_in_use = true

func disable_shield():
	if shield_in_use:
		shield_in_use = false
		

