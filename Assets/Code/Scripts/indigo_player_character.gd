extends CharacterBody2D

#Movement Variables
var speed := 100
var acceleration := 10
var deceleration := 20
var max_speed := 800
var min_speed := 400

@onready var damage_area = $DamageArea
@onready var fire_shield = $DamageArea/FireShield

func _physics_process(delta):
	position
	
	if damage_area.dead:
		return
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	var running = Input.is_action_pressed("move_fast")
	
	if running:
		speed += acceleration
		if speed > max_speed:
			speed = max_speed
	else:
		speed -= deceleration
		if speed < min_speed:
			speed = min_speed
	#print(speed)
	
	if direction.x:
		velocity.x = direction.x * speed
	if !direction.x:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction.y:
		velocity.y = direction.y * speed
	if !direction.y:
		velocity.y = move_toward(velocity.y, 0, speed)
			
	move_and_slide()
	
	
