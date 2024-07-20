extends Sprite2D



@onready var fire_shield = $"."

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	fire_shield.set_active(Input.is_action_pressed("shield_action"))
	
