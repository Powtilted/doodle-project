extends CharacterBody2D

var gravity = 800
var jump_strength = -600
var move_speed = 600
var critical_fall_speed = 1000  # Adjust this value based on desired speed threshold
var is_dead = false  # Flag to track if the player is already dead

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var nose : Sprite2D = $NoseSprite2D 
@onready var view_size = get_viewport_rect().size
@onready var Bullet = preload("res://bullet.tscn")
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound
@onready var falling_death_sound = $FallingDeathSound
@onready var shoot_sound = $ShootSound  

func wrapping_screen():
	position.x = wrapf(position.x, 0, view_size.x)

func _process(delta):
	if is_dead:
		return  # Prevent further processing if the player is dead
	
	wrapping_screen()
	
	# Apply gravity
	velocity.y += gravity * delta

	# Check if player reaches critical fall speed
	if velocity.y > critical_fall_speed:
		diefalling()

	if Input.is_action_just_pressed("shoot"):
		anim.play("shoot")
		nose.visible = true 
		shoot()

	# Check if left or right is also pressed while shooting
	if Input.is_action_pressed("move_left"):
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

	# Jump logic
	if is_on_floor():
		velocity.y = jump_strength
		jump_sound.play()

	var collision = move_and_slide()
	if collision:
		var collided_body = get_slide_collision(0).get_collider()
		if collided_body.is_in_group("enemies"):
			die()  # Only handle player's death logic, do not trigger enemy's die() here

func die():
	if is_dead:
		return  # Prevent multiple calls
	is_dead = true  # Mark the player as dead
	
	death_sound.play()
	print("Doodle is dead!")
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = true
	set_process_input(false)
	
func diefalling():
	if is_dead:
		return  # Prevent multiple calls
	is_dead = true  # Mark the player as dead
	
	falling_death_sound.play()
	print("Doodle is dead from falling!")
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true
	set_process_input(false)

func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = nose.global_position + Vector2(0, -65)
	get_parent().add_child(bullet)
	shoot_sound.play()
