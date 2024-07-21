extends AnimatedSprite2D

@onready var shield_area = $ShieldArea
@onready var cpu_particles_2d = $ShieldArea/CPUParticles2D
@onready var start_blocking_sound = $ShieldArea/StartBlockingSound
@onready var stop_blocking_sound = $ShieldArea/StopBlockingSound
@onready var get_shield = $ShieldArea/GetShield
@onready var pack_away_shield = $ShieldArea/PackAwayShield
@onready var fail_sound = $ShieldArea/FailSound
@onready var element_collision_shape = $ShieldArea/ElementCollisionShape
@onready var animated_sprite_2d = $"."

@export var scale_idle := 0.3
@export var scale_blocking := 0.38
@export var scale_element_active := 0.40

var shield_blocking := false
var shield_element_active := false
var shield_in_use := false
signal enemy_entered_shield_effect(enemy)
const ELEMENT := "FIRE"
const TYPE := "SHIELD"
var degrees
static var shield_durability := 3


func get_element():
	return ELEMENT
	
func get_type():
	return TYPE

func _ready():
	pass # Replace with function body.

func select_shield(state):
	if shield_durability <= 0:
		fail_sound.play()
		return
		
	if state and !shield_in_use:
		shield_in_use = true
		get_shield.play()
		#Set Shield Visible
		#Play Shield Get animation
	if !state and shield_in_use:
		shield_in_use = false
		pack_away_shield.play()
		#Set Shield Visible
		#Play Shield Get animation
	
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
		
	shield_area.rotation_degrees = degrees
	
func set_active(state):
	pass


	

		
func _process(delta):
	if !shield_in_use:
		print("Fire Not In Use")
		animated_sprite_2d.set_animation("off")
		animated_sprite_2d.set_scale(Vector2(scale_idle, scale_idle))
		return
	print("shield in use")
	
	#Set Flames on or off//Flames also Blocks automatically
	if Input.is_action_just_pressed("shield_action") and shield_in_use:
		cpu_particles_2d.set_emitting(true)
		element_collision_shape.disabled = false
		shield_blocking = true
		animated_sprite_2d.set_scale(Vector2(scale_element_active, scale_element_active))
	
	if Input.is_action_just_released("shield_action") and shield_in_use:
		cpu_particles_2d.set_emitting(false)
		element_collision_shape.disabled = true
		shield_blocking = false
		animated_sprite_2d.set_scale(Vector2(scale_idle, scale_idle))
		
	if degrees < 22 or degrees > 337:
		animated_sprite_2d.set_animation("right")
		animated_sprite_2d.set_z_index(3)
		cpu_particles_2d.set_z_index(2)
	if degrees > 202 and degrees < 247:
		animated_sprite_2d.set_animation("up_left")
		animated_sprite_2d.set_z_index(3)
		cpu_particles_2d.set_z_index(2)
	if degrees > 247 and degrees < 292:
		animated_sprite_2d.set_animation("up")
		animated_sprite_2d.set_z_index(3)
		cpu_particles_2d.set_z_index(2)
	if degrees > 292 and degrees < 337:
		animated_sprite_2d.set_animation("up_right")
		animated_sprite_2d.set_z_index(3)
		cpu_particles_2d.set_z_index(2)
	if degrees > 157 and degrees < 202:
		animated_sprite_2d.set_animation("left")
		animated_sprite_2d.set_z_index(3)
		cpu_particles_2d.set_z_index(2)
	if degrees > 112 and degrees < 157:
		animated_sprite_2d.set_animation("down_left")	
		animated_sprite_2d.set_z_index(6)
		cpu_particles_2d.set_z_index(7)
	if degrees > 68 and degrees < 112:
		animated_sprite_2d.set_animation("down")
		animated_sprite_2d.set_z_index(6)
		cpu_particles_2d.set_z_index(7)
	if degrees > 22 and degrees < 67:
		animated_sprite_2d.set_animation("down_right")	
		animated_sprite_2d.set_z_index(6)
		cpu_particles_2d.set_z_index(7)
	animated_sprite_2d.play()
	
	if Input.is_action_just_pressed("shield_block"):
		print("Block Start")
		shield_blocking = true
		animated_sprite_2d.set_scale(Vector2(scale_blocking, scale_blocking))
		start_blocking_sound.play()
	#animation Play blocking(degrees)
	
	if Input.is_action_just_released("shield_block"):
		print("Block Ended")
		animated_sprite_2d.set_scale(Vector2(scale_idle, scale_idle))
		shield_blocking = false
		stop_blocking_sound.play()
		#animation Play blocking(degrees)
