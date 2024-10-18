extends CharacterBody2D

var gravity = 800
var jump_strength = -500
var move_speed = 400

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var view_size = get_viewport_rect().size

func wrapping_screen():
	position.x = wrapf(position.x, 0, view_size.x)

func _process(delta):
	wrapping_screen()
	# Apply gravity
	velocity.y += gravity * delta

	# Check for left/right movement input
	if Input.is_action_pressed("move_left"):
		velocity.x = -move_speed
		anim.play("move_left")
	elif Input.is_action_pressed("move_right"):
		velocity.x = move_speed
		anim.play("move_right")
	#elif Input.is_action_pressed("shoot"):
		#anim.play("shoot")
	else:
		velocity.x = 0

	# Jump when on the ground (this assumes you later have platforms)
	if is_on_floor():
		velocity.y = jump_strength

	# Move the player using the built-in velocity
	move_and_slide()
