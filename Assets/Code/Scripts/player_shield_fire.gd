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
@onready var block_collision_shape = $ShieldArea/BlockCollisionShape
@onready var critical_hit = $ShieldArea/CriticalHit
@onready var fire_sound = $ShieldArea/FireSound

@export var scale_idle := 0.3
@export var scale_blocking := 0.38
@export var scale_element_active := 0.40
@export var shield_runtime_new := 500
@export var same_element_damage := 6
@export var different_element_damage := 15
@export var standard_durability := 3

var shield_runtime
var shield_blocking := false
var shield_element_active := false
var shield_in_use := false
signal enemy_entered_shield_effect(enemy)
signal shield_block_active(state)


const ELEMENT := "FIRE"
const TYPE := "SHIELD"
var degrees
static var shield_durability := 3


func get_element():
	return ELEMENT
	
func get_type():
	return TYPE

func _ready():
	shield_runtime = shield_runtime_new
	degrees = 0


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

	


func _process(delta):
	if !shield_in_use:
		#print("Fire Not In Use")
		animated_sprite_2d.set_animation("off")
		animated_sprite_2d.set_scale(Vector2(scale_idle, scale_idle))
		return
	print(shield_runtime)
	
	if shield_element_active:
		shield_runtime -= 1
	
	if shield_runtime <= 0:
		shield_element_active = false
	
	#Set Flames on or off//Flames also Blocks automatically
	if Input.is_action_just_pressed("shield_action") and shield_in_use:
		fire_sound.play()
		shield_runtime = shield_runtime_new
		cpu_particles_2d.set_emitting(true)
		shield_element_active = true
		element_collision_shape.disabled = false
		shield_blocking = true
		shield_block_active.emit(true)
		animated_sprite_2d.set_scale(Vector2(scale_element_active, scale_element_active))
	
	if Input.is_action_just_released("shield_action") and shield_in_use or shield_runtime < 1:
		cpu_particles_2d.set_emitting(false)
		shield_element_active = false
		element_collision_shape.disabled = true
		shield_blocking = false
		shield_block_active.emit(false)
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
	
	if Input.is_action_just_pressed("shield_block") and !shield_element_active:
		print("Block Start")
		shield_blocking = true
		shield_block_active.emit(true)
		animated_sprite_2d.set_scale(Vector2(scale_blocking, scale_blocking))
		start_blocking_sound.play()
	#animation Play blocking(degrees)
	
	if Input.is_action_just_released("shield_block") and !shield_element_active:
		print("Block Ended")
		animated_sprite_2d.set_scale(Vector2(scale_idle, scale_idle))
		shield_blocking = false
		shield_block_active.emit(false)
		stop_blocking_sound.play()
		#animation Play blocking(degrees)


#Element Weapon Code. Damage if 
func _on_shield_area_area_entered(area):
	if area.has_method("get_element") and area.has_method("set_damage"):
		if area.get_element != ELEMENT:
			critical_hit.play()
			area.set_damage(different_element_damage)
			
		if area.get_element == ELEMENT:
			area.set_damage(same_element_damage)
			

			
func _on_block_area_area_entered(area):
	if area.has_method("get_element") and area.has_method("set_damage") and shield_blocking:
		if area.get_element != ELEMENT:	
			shield_durability -= 1
	pass # Replace with function body.


func set_durability(value):
	if value == 0:
		shield_durability = standard_durability
	else:
		shield_durability = value
