extends CharacterBody2D

var gravity = 800
var jump_strength = -675
var move_speed = 600
var critical_fall_speed = 1000  # Adjust this value based on desired speed threshold
var is_dead = false  # Flag to track if the player is already dead


@onready var player_hitbox : CollisionShape2D = $CollisionShape2D
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var nose : Sprite2D = $NoseSprite2D 
@onready var jetpack_animation : AnimatedSprite2D = $JetpackSprite2D
@onready var view_size = get_viewport_rect().size
@onready var Bullet = preload("res://bullet.tscn")
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound
@onready var falling_death_sound = $FallingDeathSound
@onready var shoot_sound = $ShootSound  
@onready var jetpack_sound = $jetpack_sound
@export var backgrounds: Array[Texture] = []

var current_background = 0
var score_interval = 300
var thing = 0


func _ready():
	add_to_group("player")
	current_background = 0
	
func check_background_change():
	#if ScoreManager.score % (score_interval+1%(thing + 1)) == 0:
		#print("Score:", ScoreManager.score)
		#print("bck", current_background)
		#change_background()
	if ScoreManager.score >= (thing+ 1) * score_interval:
		print("Score:", ScoreManager.score)
		print("bck", current_background)
		change_background()

func change_background():
	if current_background < backgrounds.size():
		$"../ParallaxBackground/ParallaxLayer/Sprite2D".texture = backgrounds[current_background]
		current_background += 1
		thing +=1
	else:
		 #current_background >= backgrounds.size():
		current_background = 0
		#score_interval *= 2

func wrapping_screen():
	position.x = wrapf(position.x, 0, view_size.x)

func _process(delta):
	if is_dead:
		return  # Prevent further processing if the player is dead

	wrapping_screen()
	check_background_change()
	velocity.y += gravity * delta

	if velocity.y > critical_fall_speed:
		diefalling()

	if Input.is_action_just_pressed("shoot"):
		nose.visible = true
		anim.play("shoot")
		shoot()

	if Input.is_action_pressed("move_left"):
		velocity.x = -move_speed
		anim.play("move_left")
		nose.visible = false
		jetpack_animation.position = Vector2(42, 36)
		jetpack_animation.flip_h = false
	elif Input.is_action_pressed("move_right"):
		velocity.x = move_speed
		anim.play("move_right")
		nose.visible = false
		jetpack_animation.position = Vector2(-42, 36)
		jetpack_animation.flip_h = true
	elif Input.is_action_just_pressed("ins"):
		boost()
	else:
		velocity.x = 0
		nose.visible = false

	if is_on_floor():
		velocity.y = jump_strength
		jump_sound.play()

	var collision = move_and_slide()
	if collision:
		for i in range(get_slide_collision_count()):
			var slide_collision = get_slide_collision(i)
			var collided_body = slide_collision.get_collider()

			# Check if the collided body is valid
			if !is_instance_valid(collided_body):
				print("Collided body is no longer valid, skipping!")
				continue  # Skip this iteration if the object has been freed

			# Debug output for collision
			print("Collided with:", collided_body.name)

			# Trigger platform deletion if it has the method
			if collided_body.has_method("delete_platform"):
				collided_body.delete_platform()
			
			# Handle collision with monsters
			elif collided_body.is_in_group("enemies"):
				print("Collided with a monster!")
				die()  # Call the die function when colliding with an enemy


func die():
	if is_dead:
		return  # Prevent multiple calls
	is_dead = true  # Mark the player as dead
	
	death_sound.play()
	print("Doodle is dead!")
	#get_tree().paused = true
	set_process_input(false)
	set_process(true)
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")
	
func diefalling():
	if is_dead:
		return  # Prevent multiple calls
	is_dead = true  # Mark the player as dead
	
	falling_death_sound.play()
	print("Doodle is dead from falling!")
	#get_tree().paused = true
	set_process_input(false)
	set_process(true)
	
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")

func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = nose.global_position + Vector2(0, -65)
	get_parent().add_child(bullet)
	shoot_sound.play()
	#get_tree().change_scene_to_file("res://game_over.tscn")
	
func shrink_and_disappear():
	if is_dead:
		return
		
	is_dead = true
	var shrink_duration = 1
	var fade_duration = 1
	var steps = 30
	
	for i in range(steps):
		var scale_factor = lerp(1.0, 0.1, float(i) / steps)
		var alpha = lerp(1.0, 0.0, float(i) / steps)
		
		scale = Vector2(scale_factor, scale_factor)
		modulate.a = alpha
		
		await get_tree().create_timer(shrink_duration / steps).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")
		#print("here")
	
func boost(type = "jetpack"): # can be modified to be different boosters (rockets, propeller, etc) via parameters to be added
	player_hitbox.disabled = true
	
	if type == "jetpack":
		jetpack_sound.play()
		jetpack_animation.visible = true # can trigger different animations based on parameters if wanted
		jetpack_animation.play()
		velocity.y = -1000
		var old_gravity = gravity
		gravity = 0
		await get_tree().create_timer(2).timeout
		velocity.y = 0
		gravity = old_gravity
		jetpack_animation.visible = false
		player_hitbox.disabled = false
