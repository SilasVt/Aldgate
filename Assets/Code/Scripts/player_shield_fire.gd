extends Sprite2D

@onready var cpu_particles_2d = $CPUParticles2D
const TYPE := "Fire"
@onready var ray_cast_2d = $RayCast2D

func _ready():
	pass # Replace with function body.

func set_direction(new_direction):
	cpu_particles_2d.direction = new_direction
	print(new_direction)
	
	#Calculate Direction for raycast
	# Get the angle in radians between the direction vector and the positive x-axis
	var radians = atan2(new_direction.y, new_direction.x)
	# Convert the angle from radians to degrees
	var degrees = radians * 180 / PI
	# Normalize the angle to be between 0 and 360 degrees
	if degrees < 0:
		degrees += 360
	ray_cast_2d.rotation = degrees
			
func set_active(state):
	cpu_particles_2d.emitting = state
	ray_cast_2d.enabled = state
		

