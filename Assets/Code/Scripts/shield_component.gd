extends Node2D
class_name ShieldComponent

@export var element_area : Area2D
@export var block_area : Area2D
@export var player : PlayerInputComponent
@export var element : ElementComponent

signal attack_blocked
signal attack_not_blocked
signal element_hit_success

var shield_selected := false
var shield_rotation := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player.select_shield.connect(select_shield)
	player.new_rotation_vector.connect(set_direction)
	player.start_blocking.connect(start_blocking)
	player.stop_blocking.connect(stop_blocking)
	player.start_shield_element.connect(start_shield_element)
	player.stop_shield_element.connect(stop_shield_element)
	
#When player sends select_shield signal. check if its this element.
func select_shield(selected_element):
	if selected_element == element.get_element():
		shield_selected = true
	else:
		shield_selected = false

func start_blocking():
	if !shield_selected:
		return
	block_area.start_blocking()
	
func stop_blocking():
	if !shield_selected:
		return
	block_area.stop_blocking()

	
func start_shield_element():
	pass
	
func stop_shield_element():
	pass
	
func set_direction(new_direction):
	#Calculate Rotation for Element Area to be rotated in movement direction
	# Get the angle in radians between the direction vector and the positive x-axis
	# Convert the angle from radians to degrees
	# Normalize the angle to be between 0 and 360 degrees
	if new_direction == null:
		return
		
	var radians = atan2(new_direction.y, new_direction.x)
	shield_rotation = radians * 180 / PI
	if shield_rotation < 0:
		shield_rotation += 360
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
