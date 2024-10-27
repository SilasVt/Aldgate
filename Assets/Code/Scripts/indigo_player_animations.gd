extends AnimatedSprite2D
@onready var animated_sprite_2d = $"."
@export var min_time_between_blink := 300
@export var max_time_between_blink := 1500

static var blink_timer := 0
var idle := true
var time_since_idle := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_idle()
	blink()

func blink():
	#print(blink_timer)
	blink_timer -= 1
	if blink_timer <= 0:
		blink_timer = randi_range(min_time_between_blink, max_time_between_blink)
		animated_sprite_2d.play("idle_blinking")
		
func check_idle():
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	if direction == Vector2(0, 0):
		idle = true
		time_since_idle += 1
	else:
		time_since_idle = 0
		idle = false
