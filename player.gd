extends CharacterBody2D

var gravity = 800
var jump_strength = -500
var move_speed = 400

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var nose : Sprite2D = $NoseSprite2D 
@onready var view_size = get_viewport_rect().size
@onready var Bullet = preload("res://bullet.tscn")



func wrapping_screen():
	position.x = wrapf(position.x, 0, view_size.x)

func _process(delta):
	wrapping_screen()
	# Apply gravity
	velocity.y += gravity * delta


	if Input.is_action_just_pressed("shoot"):
		anim.play("shoot")
		nose.visible = true 
		shoot()

		## Check if left or right is also pressed while shooting
		if Input.is_action_pressed("move_left"):
			velocity.x = -move_speed	
		elif Input.is_action_pressed("move_right"):
			velocity.x = move_speed
		else:
			velocity.x = 0
	
	elif Input.is_action_pressed("move_left"):
		velocity.x = -move_speed
		anim.play("move_left")
		nose.visible = false  # Hide nose when only moving
	elif Input.is_action_pressed("move_right"):
		velocity.x = move_speed
		anim.play("move_right")
		nose.visible = false  # Hide nose when only moving
	else:
		velocity.x = 0
		nose.visible = false  # Hide nose when idle

	if is_on_floor():
		velocity.y = jump_strength
		
	var collision = move_and_slide()
	if collision:
		var collided_body = get_slide_collision(0).get_collider()
		if collided_body.is_in_group("enemies"):
			die()
			
func die():
	print("Doodle is dead!")
	get_tree().paused = true
	set_process_input(false)
	
func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = nose.global_position + Vector2(0, -65)
	get_parent().add_child(bullet)
