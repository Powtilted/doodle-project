extends CharacterBody2D

var gravity = 800
var jump_strength = -400
var move_speed = 200

func _process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	# Check for left/right movement input
	if Input.is_action_pressed("ui_left"):
		velocity.x = -move_speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = move_speed
	else:
		velocity.x = 0

	# Jump when on the ground (this assumes you later have platforms)
	if is_on_floor():
		velocity.y = jump_strength

	# Move the player using the built-in velocity
	move_and_slide()
