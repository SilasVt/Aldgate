extends AudioStreamPlayer2D
# Script attached to the AudioStreamPlayer
@export var target_volume_db = 0.0
@export var fade_speed = 1.0  # The rate at which to fade in dB per second

var ending := false

func set_volume(new_volume):
	target_volume_db = new_volume
	
func set_ending():
	ending = true
	
	
func _process(delta):
	if abs(volume_db - target_volume_db) > 0.1:
		volume_db = lerp(volume_db, target_volume_db, fade_speed * delta)
	#Once volume is at 0 and was set to end, stop playback and free stream memory
	if volume_db == 0 and ending:
		stop()
		stream = null
		ending = false

func fade_to(target_volume: float, speed: float):
	target_volume_db = target_volume
	fade_speed = speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
