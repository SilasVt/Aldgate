extends Sprite2D

@onready var shield_area = $ShieldArea
@onready var collision_shape_2d = $ShieldArea/CollisionShape2D
@onready var cpu_particles_2d = $ShieldArea/CPUParticles2D
@onready var start_blocking_sound = $ShieldArea/StartBlockingSound
@onready var stop_blocking_sound = $ShieldArea/StopBlockingSound

var shield_blocking := false
var shield_element_active := false
signal enemy_entered_shield_effect(enemy)
const ELEMENT := "FIRE"
const TYPE := "SHIELD"
var degrees


func get_element():
	return ELEMENT
	
func get_type():
	return TYPE

func _ready():
	pass # Replace with function body.

func set_direction(new_direction):
	#Calculate Direction for raycast
	# Get the angle in radians between the direction vector and the positive x-axis
	# Convert the angle from radians to degrees
	# Normalize the angle to be between 0 and 360 degrees
	var radians = atan2(new_direction.y, new_direction.x)
	degrees = radians * 180 / PI
	if degrees < 0:
		degrees += 360
		
	shield_area.rotation_degrees = degrees
	
func set_active(state):
	cpu_particles_2d.set_emitting(state)
	collision_shape_2d.disabled = !state

		
func _process(delta):
	#if ray_cast_2d.is_colliding():
		#var collider = shield_raycast.get_collider()
	if Input.is_action_just_pressed("shield_block"):
		shield_blocking = true
		start_blocking_sound.play()
	#animation Play blocking(degrees)
	
	if Input.is_action_just_released("shield_block"):
		shield_blocking = false
		stop_blocking_sound.play()
		#animation Play blocking(degrees)

