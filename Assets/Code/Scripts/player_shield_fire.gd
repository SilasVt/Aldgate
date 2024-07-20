extends Sprite2D

@onready var cpu_particles_2d = $CPUParticles2D
const TYPE := "Fire"

func _ready():
	pass # Replace with function body.

func set_direction(new_direction):
	cpu_particles_2d.direction = new_direction
		
func set_active(state):
	cpu_particles_2d.emitting = state
