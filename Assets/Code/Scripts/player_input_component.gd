extends Node2D
class_name PlayerInputComponent

@export var fire_shield : HealthComponent

signal select_shield(element)
signal new_rotation_vector(rotation_vector) #Sends new rotation to shields
signal start_shield_element #Sets a shield to activate or deactivate its element power
signal stop_shield_element
signal start_blocking
signal stop_blocking

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
